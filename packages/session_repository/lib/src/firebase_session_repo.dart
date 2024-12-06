import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:session_repository/session_repository.dart';

class FirebaseSessionRepo implements SessionRepository {
  final sessionCollection = FirebaseFirestore.instance.collection('sessions');
  final nannyConnectionsCollection =
      FirebaseFirestore.instance.collection('nannyConnections');

  FirebaseSessionRepo();
//SESION
  @override
  Future<void> addSession(Session session) async {
    try {
      await sessionCollection
          .doc(session.sessionId)
          .set(session.toEntity().toDocument());
    } catch (e) {
      log('Error adding session: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeSession(String sessionId) async {
    try {
      await sessionCollection.doc(sessionId).delete();
    } catch (e) {
      log('Error removing session: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Session>> checkSessionConflict(
    String parentId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await sessionCollection
          .where('parentsId', arrayContains: parentId)
          .where('startDate', isLessThan: endDate)
          .get();

      // Filter results based on endDate
      List<Session> conflictingSessions = querySnapshot.docs
          .map((doc) => SessionEntity.fromDocument(doc).toModel())
          .where((session) => session.endDate.isAfter(startDate))
          .toList();

      return conflictingSessions;
    } catch (e) {
      log('Error checking session conflicts: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Session>> getSessions(
    List<String> sessionIds,
  ) async {
    List<Session> sessions = [];

    for (String sessionId in sessionIds) {
      DocumentSnapshot sessionSnapshot =
          await sessionCollection.doc(sessionId).get();

      if (sessionSnapshot.exists) {
        Session session = SessionEntity.fromDocument(sessionSnapshot).toModel();
        sessions.add(session);
      }
    }
    return sessions;
  }

  @override
  Future<List<Session>> getSessionsByParentsId(
    List<String> parentsId,
  ) async {
    try {
      // Perform initial query based on 'parentsId'
      final querySnapshot = await sessionCollection
          .where('parentsId', arrayContainsAny: parentsId)
          .get();

      // Map initial query results to a list of sessions
      List<Session> sessions = querySnapshot.docs
          .map((doc) => SessionEntity.fromDocument(doc).toModel())
          .toList();

      // If the list contains only one item, add an additional query for 'nannyId'
      if (parentsId.length == 1) {
        final additionalQuerySnapshot = await sessionCollection
            .where('nannyId', isEqualTo: parentsId.first)
            .get();

        // Map additional query results to a list of sessions
        List<Session> additionalSessions = additionalQuerySnapshot.docs
            .map((doc) => SessionEntity.fromDocument(doc).toModel())
            .toList();

        // Combine both sets of results (avoiding duplicates)
        sessions = [...sessions, ...additionalSessions];
      }

      return sessions;
    } catch (e) {
      log('Error getting sessions by parentsId: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateSession(Session session) async {
    try {
      await sessionCollection
          .doc(session.sessionId)
          .update(session.toEntity().toDocument());
    } catch (e) {
      log('Error updating session: ${e.toString()}');
      rethrow;
    }
  }

// ADD NANNY TO SESSION
  @override
  Future<void> sendNannyConnectionRequest({
    required String sessionId,
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String receiverEmail,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Check for existing request
    final existingRequest = await nannyConnectionsCollection
        .where('senderId', isEqualTo: senderId)
        .where('sessionId', isEqualTo: sessionId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (existingRequest.docs.isNotEmpty) {
      final currentReceiverEmail =
          existingRequest.docs.first.data()['receiverEmail'] as String? ??
              'unknown';
      throw Exception('Request already sent to $currentReceiverEmail');
    }

    // Create new connection request
    await nannyConnectionsCollection.add({
      'sessionId': sessionId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'receiverEmail': receiverEmail,
      'status': 'pending',
      'startDate': startDate,
      'endDate': endDate,
      'requestTime': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<NannyConnections>> loadIncomingNannyRequests(
      String userId) async {
    final querySnapshot = await nannyConnectionsCollection
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return NannyConnections(
        connectionId: doc.id,
        sessionId: data['sessionId'],
        senderId: data['senderId'],
        senderEmail: data['senderEmail'],
        receiverId: data['receiverId'],
        receiverEmail: data['receiverEmail'],
        status: data['status'],
        startDate: (data['startDate'] as Timestamp).toDate(),
        endDate: (data['endDate'] as Timestamp).toDate(),
        requestTime: (data['requestTime'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> acceptNannyConnectionRequest(String requestId) async {
    final requestRef = nannyConnectionsCollection.doc(requestId);
    final requestDoc = await requestRef.get();

    if (requestDoc.exists && requestDoc['status'] == 'pending') {
      await requestRef.update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('Invalid or already processed request.');
    }
  }

  @override
  Future<void> declineNannyConnectionRequest(String requestId) async {
    final requestRef = nannyConnectionsCollection.doc(requestId);
    await requestRef.update({
      'status': 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> unlinkNannyConnection(String sessionId) async {
    final connectionsQuery = await nannyConnectionsCollection
        .where('sessionId', isEqualTo: sessionId)
        .where('status', isEqualTo: 'accepted')
        .get();

    for (var doc in connectionsQuery.docs) {
      await doc.reference.update({
        'status': 'unlinked',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<NannyConnections> getNannyConnectionRequest(String requestId) async {
    final requestRef = nannyConnectionsCollection.doc(requestId);
    final requestDoc = await requestRef.get();

    if (!requestDoc.exists) {
      throw Exception('Connection request not found.');
    }

    final data = requestDoc.data()!;
    return NannyConnections(
      sessionId: data['sessionId'],
      connectionId: requestDoc.id,
      senderId: data['senderId'],
      senderEmail: data['senderEmail'],
      receiverId: data['receiverId'],
      receiverEmail: data['receiverEmail'],
      status: data['status'],
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

//ACTIVITY

  @override
  Future<void> addActivity(String sessionId, Activity activity) async {
    try {
      final docRef = await sessionCollection
          .doc(sessionId)
          .collection('activities')
          .add(activity.toEntity().toDocument());

      await docRef.update({'activityId': docRef.id});
    } catch (e) {
      log('Error adding activity: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateActivity(String sessionId, Activity activity) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('activities')
          .doc(activity.activityId)
          .update(activity.toEntity().toDocument());
    } catch (e) {
      log('Error updating activity: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteActivity(String sessionId, String activityId) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('activities')
          .doc(activityId)
          .delete();
    } catch (e) {
      log('Error deleting activity: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Stream<List<Activity>> getActivities(String sessionId) {
    return sessionCollection
        .doc(sessionId)
        .collection('activities')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Activity.fromEntity(ActivityEntity.fromDocument(doc));
            }).toList());
  }

//MEAL

  @override
  Future<void> addMeal(String sessionId, Meal meal) async {
    try {
      final docRef = await sessionCollection
          .doc(sessionId)
          .collection('meals')
          .add(meal.toEntity().toDocument());

      await docRef.update({'mealId': docRef.id});
    } catch (e) {
      log('Error adding meal: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateMeal(String sessionId, Meal meal) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('meals')
          .doc(meal.mealId)
          .update(meal.toEntity().toDocument());
    } catch (e) {
      log('Error updating meal: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteMeal(String sessionId, String mealId) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('meals')
          .doc(mealId)
          .delete();
    } catch (e) {
      log('Error deleting meal: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Stream<List<Meal>> getMeals(String sessionId) {
    return sessionCollection
        .doc(sessionId)
        .collection('meals')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Meal.fromEntity(MealEntity.fromDocument(doc));
            }).toList());
  }

// NOTES

  @override
  Future<void> addNote(String sessionId, Note note) async {
    try {
      final docRef = await sessionCollection
          .doc(sessionId)
          .collection('note')
          .add(note.toEntity().toDocument());

      await docRef.update({'noteId': docRef.id});
    } catch (e) {
      log('Error adding note: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateNote(String sessionId, Note note) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('notes')
          .doc(note.noteId)
          .update(note.toEntity().toDocument());
    } catch (e) {
      log('Error updating note: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteNote(String sessionId, String noteId) async {
    try {
      await sessionCollection
          .doc(sessionId)
          .collection('note')
          .doc(noteId)
          .delete();
    } catch (e) {
      log('Error deleting note: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Stream<List<Note>> getNotes(String sessionId) {
    return sessionCollection
        .doc(sessionId)
        .collection('note')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Note.fromEntity(NoteEntity.fromDocument(doc));
            }).toList());
  }
}
