part of 'session_management_bloc.dart';

abstract class SessionManagementState extends Equatable {
  const SessionManagementState();

  @override
  List<Object?> get props => [];
}

class SessionManagementInitial extends SessionManagementState {}

class SessionManagementLoading extends SessionManagementState {}

class SessionManagementSuccess extends SessionManagementState {}

class SessionManagementFailure extends SessionManagementState {
  final String error;

  const SessionManagementFailure(this.error);

  @override
  List<Object?> get props => [error];
}
