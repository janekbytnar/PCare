import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:session_repository/session_repository.dart';

import 'models/models.dart';

class FirebaseSessionRepo implements SessionRepository {
  final sessionCollection = FirebaseFirestore.instance.collection('sessions');

  FirebaseSessionRepo();

  @override
  Future<void> addSession(
    Session session,
    List<String> parents,
    String childId,
    String nannyId,
  ) async {
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
}
