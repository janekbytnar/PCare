import 'package:equatable/equatable.dart';
import 'package:child_repository/child_repository.dart';

abstract class ChildrenManagementEvent extends Equatable {
  const ChildrenManagementEvent();

  @override
  List<Object?> get props => [];
}

class AddChildEvent extends ChildrenManagementEvent {
  final Child child;
  final String userId;

  const AddChildEvent(
    this.child,
    this.userId,
  );

  @override
  List<Object?> get props => [child];
}

class RemoveChildEvent extends ChildrenManagementEvent {
  final String childId;

  const RemoveChildEvent(this.childId);

  @override
  List<Object?> get props => [childId];
}
