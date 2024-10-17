import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Child extends Equatable {
  final String id;
  final String name;
  final List<String> parentIds;
  final DateTime dateOfBirth;

  const Child({
    required this.id,
    required this.name,
    required this.parentIds,
    required this.dateOfBirth,
  });

  static final empty = Child(
    id: '',
    name: '',
    parentIds: const [],
    dateOfBirth: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Child copyWith({
    String? id,
    String? name,
    List<String>? parentIds,
    DateTime? dateOfBirth,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      parentIds: parentIds ?? this.parentIds,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  ChildEntity toEntity() {
    return ChildEntity(
      id: id,
      name: name,
      parentIds: parentIds,
      dateOfBirth: dateOfBirth,
    );
  }

  static Child fromEntity(ChildEntity entity) {
    return Child(
      id: entity.id,
      name: entity.name,
      parentIds: entity.parentIds,
      dateOfBirth: entity.dateOfBirth,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        parentIds,
        dateOfBirth,
      ];
}
