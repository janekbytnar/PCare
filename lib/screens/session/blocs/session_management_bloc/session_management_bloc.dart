import 'package:bloc/bloc.dart';
import 'package:child_repository/child_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'session_management_event.dart';
part 'session_management_state.dart';

class SessionManagementBloc
    extends Bloc<SessionManagementEvent, SessionManagementState> {
  final SessionRepository sessionRepository;
  final ChildRepository childRepository;
  final UserRepository userRepository;

  SessionManagementBloc({
    required this.sessionRepository,
    required this.childRepository,
    required this.userRepository,
  }) : super(SessionManagementInitial()) {
    on<AddSessionEvent>(_onAddSession);
    on<RemoveSessionEvent>(_onRemoveSession);
  }

  Future<void> _onAddSession(
      AddSessionEvent event, Emitter<SessionManagementState> emit) async {
    emit(SessionManagementLoading());
    try {
      await sessionRepository.addSession(event.session);

      for (var parentId in event.session.parentsId) {
        await userRepository.connectSessionToUser(
          parentId,
          event.session.sessionId,
        );
      }

      for (var childId in event.session.childsId) {
        await childRepository.connectSessionToChild(
          childId,
          event.session.sessionId,
        );
      }

      emit(SessionManagementSuccess());
    } catch (e) {
      emit(SessionManagementFailure(e.toString()));
    }
  }

  Future<void> _onRemoveSession(
      RemoveSessionEvent event, Emitter<SessionManagementState> emit) async {
    emit(SessionManagementLoading());
    try {
      await sessionRepository.removeSession(event.sessionId);
      emit(SessionManagementSuccess());
    } catch (e) {
      emit(SessionManagementFailure(e.toString()));
    }
  }
}
