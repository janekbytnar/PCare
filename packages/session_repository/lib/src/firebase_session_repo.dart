import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:session_repository/session_repository.dart';

import 'models/models.dart';

class FirebaseSessionRepo implements SessionRepository {
  final sessionCollection = FirebaseFirestore.instance.collection('sessions');

  FirebaseSessionRepo();

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
          .where('endDate', isGreaterThan: startDate)
          .get();

      return querySnapshot.docs
          .map((doc) => SessionEntity.fromDocument(doc).toModel())
          .toList();
    } catch (e) {
      log('Error getting sessions for parent: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Session>> getSessions(
    List<String> sessionIds,
  ) async {
    List<Session> sessions = [];

    for (String sessionId in sessionIds) {
      DocumentSnapshot sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .doc(sessionId)
          .get();

      if (sessionSnapshot.exists) {
        Session session = SessionEntity.fromDocument(sessionSnapshot).toModel();
        sessions.add(session);
      }
    }
    return sessions;
  }
}
