part of 'nanny_connection_management_bloc.dart';

sealed class NannyConnectionsManagementState extends Equatable {
  const NannyConnectionsManagementState();

  @override
  List<Object?> get props => [];
}

class NannyConnectionManagementInitial
    extends NannyConnectionsManagementState {}

class NannyConnectionsLoading extends NannyConnectionsManagementState {}

class NannyConnectionsLoaded extends NannyConnectionsManagementState {
  final List<NannyConnections> requests;

  const NannyConnectionsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class NannyConnectionRequestSent extends NannyConnectionsManagementState {}

class NannyConnectionRequestAccepted extends NannyConnectionsManagementState {}

class NannyConnectionRequestDeclined extends NannyConnectionsManagementState {}

class NannyConnectionUnlinked extends NannyConnectionsManagementState {}

class NannyConnectionsError extends NannyConnectionsManagementState {
  final String message;

  const NannyConnectionsError(this.message);

  @override
  List<Object?> get props => [message];
}
