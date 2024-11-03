part of 'children_bloc.dart';

abstract class ChildrenEvent extends Equatable {
  const ChildrenEvent();

  @override
  List<Object?> get props => [];
}

class ChildrenStatusChanged extends ChildrenEvent {
  final MyUser? user;

  const ChildrenStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class ChildrenUpdated extends ChildrenEvent {
  final List<Child> children;

  const ChildrenUpdated(this.children);

  @override
  List<Object?> get props => [children];
}
