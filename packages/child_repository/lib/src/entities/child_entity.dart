import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child.dart'; // Import modelu Child

class ChildEntity {
  final String id;
  final String name;
  final List<String> parentIds;
  final DateTime dateOfBirth;
  final List<String> sessionIds;

  const ChildEntity({
    required this.id,
    required this.name,
    required this.parentIds,
    required this.dateOfBirth,
    this.sessionIds = const [],
  });

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'parent_ids': parentIds,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
      'session_ids': sessionIds,
    };
  }

  static ChildEntity fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChildEntity(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      parentIds: List<String>.from(data['parent_ids'] ?? []),
      dateOfBirth: (data['date_of_birth'] as Timestamp).toDate(),
      sessionIds: List<String>.from(data['session_ids'] ?? []),
    );
  }

  Child toModel() {
    return Child(
      id: id,
      name: name,
      parentIds: parentIds,
      dateOfBirth: dateOfBirth,
      sessionIds: sessionIds,
    );
  }
}
