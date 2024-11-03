part of 'session_management_bloc.dart';

sealed class SessionManagementEvent extends Equatable {
  const SessionManagementEvent();

  @override
  List<Object?> get props => [];
}

class AddSessionEvent extends SessionManagementEvent {
  final Session session;

  const AddSessionEvent(
    this.session,
  );

  @override
  List<Object?> get props => [session];
}

class RemoveSessionEvent extends SessionManagementEvent {
  final String sessionId;

  const RemoveSessionEvent(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}
