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
