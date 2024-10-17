import 'package:equatable/equatable.dart';

abstract class ChildrenManagementState extends Equatable {
  const ChildrenManagementState();

  @override
  List<Object?> get props => [];
}

class ChildrenManagementInitial extends ChildrenManagementState {}

class ChildrenManagementLoading extends ChildrenManagementState {}

class ChildrenManagementSuccess extends ChildrenManagementState {}

class ChildrenManagementFailure extends ChildrenManagementState {
  final String error;

  const ChildrenManagementFailure(this.error);

  @override
  List<Object?> get props => [error];
}
