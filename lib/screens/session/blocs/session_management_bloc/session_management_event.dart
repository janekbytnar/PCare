part of 'session_management_bloc.dart';

sealed class SessionManagementEvent extends Equatable {
  const SessionManagementEvent();

  @override
  List<Object?> get props => [];
}

class AddSessionEvent extends SessionManagementEvent {
  final Session session;
  final List<String> parents;
  final String childId;
  final String nannyId;

  const AddSessionEvent(
    this.session,
    this.parents,
    this.childId,
    this.nannyId,
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
