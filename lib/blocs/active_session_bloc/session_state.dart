part of 'session_bloc.dart';

enum SessionStatus { active, inactive, unknown, loading, failure }

class SessionState extends Equatable {
  final SessionStatus status;
  final String? error;

  const SessionState._({
    this.status = SessionStatus.unknown,
    this.error,
  });

  const SessionState.unknown() : this._();

  const SessionState.loading() : this._(status: SessionStatus.loading);

  const SessionState.active(
    List<Session> sessions,
  ) : this._(status: SessionStatus.active);

  const SessionState.inactive() : this._(status: SessionStatus.inactive);

  const SessionState.failure(String error)
      : this._(status: SessionStatus.failure, error: error);
  @override
  List<Object> get props => [status];
}
