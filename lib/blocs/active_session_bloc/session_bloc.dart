import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  SessionBloc({
    required this.userRepository,
  }) : super(const SessionState.unknown()) {
    _userSubscription =
        userRepository.getCurrentUserDataStream().listen((myUser) {
      add(SessionStatusChanged(myUser));
    });
    on<SessionStatusChanged>(_onStatusChanged);
  }

  Future<void> _onStatusChanged(
      SessionStatusChanged event, Emitter<SessionState> emit) async {
    final user = event.user;
    if (user != null && user.sessions.isNotEmpty) {
      emit(const SessionState.loading());
      try {
        List<Session> sessions =
            await userRepository.getSessions(user.sessions);
        final today = DateTime.now();
        final hasSessionToday = sessions.any((session) {
          return session.startDate.year == today.year &&
              session.startDate.month == today.month &&
              session.startDate.day == today.day;
        });
        if (hasSessionToday) {
          emit(SessionState.active(sessions));
        } else {
          emit(const SessionState.inactive());
        }
      } catch (e) {
        emit(SessionState.failure(e.toString()));
      }
    } else {
      emit(const SessionState.inactive());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
