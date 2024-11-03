import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final UserRepository userRepository;
  final SessionRepository sessionRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  SessionBloc({
    required this.userRepository,
    required this.sessionRepository,
  }) : super(const SessionState.unknown()) {
    _userSubscription =
        userRepository.getCurrentUserDataStream().listen((myUser) {
      add(SessionStatusChanged(myUser));
    });
    on<SessionStatusChanged>(_onStatusChanged);
    on<LoadSessionsForDate>(_onLoadSessionsForDate);
  }

  Future<void> _onStatusChanged(
      SessionStatusChanged event, Emitter<SessionState> emit) async {
    final user = event.user;
    final today = DateTime.now();
    if (user != null && user.sessions.isNotEmpty) {
      emit(SessionState.loading(selectedDate: today));
      try {
        List<Session> sessions =
            await sessionRepository.getSessions(user.sessions);
        // Filter sessions for today
        List<Session> sessionsToday = sessions.where((session) {
          return session.startDate.year == today.year &&
              session.startDate.month == today.month &&
              session.startDate.day == today.day;
        }).toList();

        if (sessionsToday.isNotEmpty) {
          emit(SessionState.active(sessionsToday, today));
        } else {
          emit(SessionState.inactive(today));
        }
      } catch (e) {
        emit(SessionState.failure(e.toString(), selectedDate: today));
      }
    } else {
      emit(SessionState.inactive(today));
    }
  }

  Future<void> _onLoadSessionsForDate(
      LoadSessionsForDate event, Emitter<SessionState> emit) async {
    emit(SessionState.loading(selectedDate: event.selectedDate));
    try {
      final user = await userRepository.getCurrentUserData();
      if (user != null && user.sessions.isNotEmpty) {
        // Fetch all sessions of the user
        List<Session> sessions =
            await sessionRepository.getSessions(user.sessions);

        // Filter sessions for the selected date
        List<Session> sessionsForDate = sessions.where((session) {
          return session.startDate.year == event.selectedDate.year &&
              session.startDate.month == event.selectedDate.month &&
              session.startDate.day == event.selectedDate.day;
        }).toList();

        if (sessionsForDate.isNotEmpty) {
          emit(SessionState.active(
            sessionsForDate,
            event.selectedDate,
          ));
        } else {
          emit(SessionState.inactive(event.selectedDate));
        }
      } else {
        emit(SessionState.inactive(event.selectedDate));
      }
    } catch (e) {
      emit(
          SessionState.failure(e.toString(), selectedDate: event.selectedDate));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
