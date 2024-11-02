import 'dart:developer';

import 'package:child_repository/child_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChildRepo implements ChildRepository {
  final childrenCollection = FirebaseFirestore.instance.collection('children');

  FirebaseChildRepo();

  @override
  Future<void> addChild(Child child) async {
    try {
      await childrenCollection.doc(child.id).set(child.toEntity().toDocument());
    } catch (e) {
      log('Error adding child: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeChild(String childId) async {
    try {
      await childrenCollection.doc(childId).delete();
    } catch (e) {
      log('Error removing child: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> updateChild(Child child) async {
    try {
      await childrenCollection
          .doc(child.id)
          .update(child.toEntity().toDocument());
    } catch (e) {
      throw Exception('Failed to update child: $e');
    }
  }

  @override
  Stream<List<Child>> getChildrenForUserStream(String userId) {
    return childrenCollection
        .where('parent_ids', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Child.fromEntity(ChildEntity.fromDocument(doc));
            }).toList());
  }

  @override
  Future<void> connectSessionToChild(String childId, String sessionId) async {
    try {
      await childrenCollection.doc(childId).update({
        'session_ids': FieldValue.arrayUnion([sessionId])
      });
    } catch (e) {
      log('Error connecting session to child: ${e.toString()}');
      rethrow;
    }
  }
}
