import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child.dart'; // Import modelu Child

class ChildEntity {
  final String id;
  final String name;
  final List<String> parentIds;
  final DateTime dateOfBirth;

  const ChildEntity({
    required this.id,
    required this.name,
    required this.parentIds,
    required this.dateOfBirth,
  });

  // Tworzenie dokumentu Firestore
  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'parent_ids': parentIds,
      'date_of_birth': Timestamp.fromDate(dateOfBirth),
    };
  }

  // Odtwarzanie encji z dokumentu Firestore
  static ChildEntity fromDocument(DocumentSnapshot doc) {
    return ChildEntity(
      id: doc['id'] ?? '',
      name: doc['name'] ?? '',
      parentIds: List<String>.from(doc['parent_ids']),
      dateOfBirth: (doc['date_of_birth'] as Timestamp).toDate(),
    );
  }

  // Konwersja encji na model Child
  Child toModel() {
    return Child(
      id: id,
      name: name,
      parentIds: parentIds,
      dateOfBirth: dateOfBirth,
    );
  }
}
