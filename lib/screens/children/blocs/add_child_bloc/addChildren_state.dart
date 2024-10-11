// lib/screens/children/blocs/children_state.dart

part of 'addChildren_bloc.dart';

abstract class AddChildrenState {}

class ChildrenInitial extends AddChildrenState {}

class ChildrenLoading extends AddChildrenState {}

class ChildrenLoaded extends AddChildrenState {
  final List<Child> children;

  ChildrenLoaded({required this.children});
}

class ChildrenError extends AddChildrenState {
  final String error;

  ChildrenError({required this.error});
}
