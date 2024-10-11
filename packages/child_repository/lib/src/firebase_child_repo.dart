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
  Future<List<Child>> getChildrenForUser(String userId) async {
    try {
      final querySnapshot = await childrenCollection
          .where('parent_ids', arrayContains: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => ChildEntity.fromDocument(doc).toModel())
          .toList();
    } catch (e) {
      log('Error fetching children: ${e.toString()}');
      rethrow;
    }
  }
}
