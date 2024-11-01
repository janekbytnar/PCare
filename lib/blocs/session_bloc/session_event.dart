part of 'session_bloc.dart';

sealed class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class SessionStatusChanged extends SessionEvent {
  final MyUser? user;

  const SessionStatusChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class LoadSessionsForDate extends SessionEvent {
  final DateTime selectedDate;
  const LoadSessionsForDate(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}
