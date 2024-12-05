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
    on<StopListeningSession>((event, emit) async {
      await _userSubscription.cancel();
      emit(const SessionState.unknown());
    });
  }

  Future<void> _onStatusChanged(
      SessionStatusChanged event, Emitter<SessionState> emit) async {
    final user = event.user;
    final today = DateTime.now();
    if (user != null) {
      emit(SessionState.loading(selectedDate: today));
      Set<String> sessionsId = {};
      if (user.sessions.isNotEmpty) {
        sessionsId.addAll(user.sessions);
      }
      final linkedPersonId = user.linkedPerson;

      try {
        if (linkedPersonId.isNotEmpty) {
          final linkedPerson = await userRepository.getUserById(linkedPersonId);
          if (linkedPerson != null && linkedPerson.sessions.isNotEmpty) {
            List<String> linkedPersonSessionsId = linkedPerson.sessions;
            sessionsId.addAll(linkedPersonSessionsId);
          }
        }
        if (sessionsId.isEmpty) {
          emit(SessionState.inactive(today));
          return;
        }

        List<Session> sessions =
            await sessionRepository.getSessions(sessionsId.toList());
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

      if (user != null) {
        Set<String> sessionsId = {};

// Fetch all sessions of the user if exists
        if (user.sessions.isNotEmpty) {
          sessionsId.addAll(user.sessions);
        }

        final linkedPersonId = user.linkedPerson;

        //fetch all sessions of the linked person if exists
        if (linkedPersonId.isNotEmpty) {
          final linkedPerson = await userRepository.getUserById(linkedPersonId);
          if (linkedPerson != null && linkedPerson.sessions.isNotEmpty) {
            List<String> linkedPersonSessionsId = linkedPerson.sessions;
            sessionsId.addAll(linkedPersonSessionsId);
          }
        }
        if (sessionsId.isEmpty) {
          emit(SessionState.inactive(event.selectedDate));
          return;
        }

        List<Session> sessions =
            await sessionRepository.getSessions(sessionsId.toList());

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
