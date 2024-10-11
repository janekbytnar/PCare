import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Child extends Equatable {
  final String id;
  final String name;
  final List<String> parentIds;

  const Child({
    required this.id,
    required this.name,
    required this.parentIds,
  });

  static const empty = Child(
    id: '',
    name: '',
    parentIds: [],
  );

  Child copyWith({
    String? id,
    String? name,
    List<String>? parentIds,
  }) {
    return Child(
      id: id ?? this.id,
      name: name ?? this.name,
      parentIds: parentIds ?? this.parentIds,
    );
  }

  ChildEntity toEntity() {
    return ChildEntity(
      id: id,
      name: name,
      parentIds: parentIds,
    );
  }

  static Child fromEntity(ChildEntity entity) {
    return Child(
      id: entity.id,
      name: entity.name,
      parentIds: entity.parentIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        parentIds,
      ];
}
