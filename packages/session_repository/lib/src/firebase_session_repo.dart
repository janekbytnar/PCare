import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:session_repository/session_repository.dart';

class FirebaseSessionRepo implements SessionRepository {
  final sessionCollection = FirebaseFirestore.instance.collection('sessions');

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
}
