part of 'connections_management_bloc.dart';

abstract class ConnectionsManagementState extends Equatable {
  const ConnectionsManagementState();

  @override
  List<Object?> get props => [];
}

class ConnectionsInitial extends ConnectionsManagementState {}

class ConnectionsLoading extends ConnectionsManagementState {}

class ConnectionsLoaded extends ConnectionsManagementState {
  final List<Connections> requests;

  const ConnectionsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class ConnectionRequestSent extends ConnectionsManagementState {}

class ConnectionRequestAccepted extends ConnectionsManagementState {}

class ConnectionRequestDeclined extends ConnectionsManagementState {}

class ConnectionUnlinked extends ConnectionsManagementState {}

class ConnectionsError extends ConnectionsManagementState {
  final String message;

  const ConnectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
