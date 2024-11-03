part of 'session_bloc.dart';

enum SessionStatus { active, inactive, unknown, loading, failure }

class SessionState extends Equatable {
  final SessionStatus status;
  final List<Session> sessions;
  final DateTime? selectedDate;
  final String? error;

  const SessionState._({
    this.sessions = const [],
    this.status = SessionStatus.unknown,
    this.selectedDate,
    this.error,
  });

  const SessionState.unknown() : this._();

  const SessionState.loading({required DateTime selectedDate})
      : this._(status: SessionStatus.loading);

  const SessionState.active(
    List<Session> sessions,
    DateTime selectedDate,
  ) : this._(
          status: SessionStatus.active,
          sessions: sessions,
          selectedDate: selectedDate,
        );

  const SessionState.inactive(DateTime selectedDate)
      : this._(
          status: SessionStatus.inactive,
          selectedDate: selectedDate,
        );

  const SessionState.failure(String error, {required DateTime selectedDate})
      : this._(
          status: SessionStatus.failure,
          error: error,
        );
  @override
  List<Object?> get props => [status, sessions, selectedDate, error];
}
