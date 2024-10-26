part of 'session_bloc.dart';

enum SessionStatus { active, inactive, unknown, loading, failure }

class SessionState extends Equatable {
  final SessionStatus status;
  final List<Session> sessions;
  final String? error;

  const SessionState._({
    this.sessions = const [],
    this.status = SessionStatus.unknown,
    this.error,
  });

  const SessionState.unknown() : this._();

  const SessionState.loading() : this._(status: SessionStatus.loading);

  const SessionState.active(
    List<Session> sessions,
  ) : this._(status: SessionStatus.active, sessions: sessions);

  const SessionState.inactive() : this._(status: SessionStatus.inactive);

  const SessionState.failure(String error)
      : this._(status: SessionStatus.failure, error: error);
  @override
  List<Object> get props => [status];
}
