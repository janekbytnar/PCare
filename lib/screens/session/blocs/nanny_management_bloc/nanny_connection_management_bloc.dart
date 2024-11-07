import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'nanny_connection_management_event.dart';
part 'nanny_connection_management_state.dart';

class NannyConnectionsManagementBloc extends Bloc<
    NannyConnectionsManagementEvent, NannyConnectionsManagementState> {
  final SessionRepository sessionRepository;
  final UserRepository userRepository;

  NannyConnectionsManagementBloc({
    required this.sessionRepository,
    required this.userRepository,
  }) : super(NannyConnectionManagementInitial()) {
    on<SendNannyConnectionRequest>(_onSendNannyConnectionRequest);
    on<LoadNannyConnectionRequests>(_onLoadNannyConnectionRequests);
    on<AcceptNannyConnectionRequest>(_onAcceptNannyConnectionRequest);
    on<DeclineNannyConnectionRequest>(_onDeclineNannyConnectionRequest);
    on<UnlinkNannyConnection>(_onUnlinkNannyConnection);
  }

  Future<void> _onSendNannyConnectionRequest(SendNannyConnectionRequest event,
      Emitter<NannyConnectionsManagementState> emit) async {
    emit(NannyConnectionsLoading());
    final normalizedReceiverEmail = event.receiverEmail.toLowerCase();

    try {
      final receiverId =
          await userRepository.getUserIdByEmail(normalizedReceiverEmail);

      if (receiverId == null) {
        throw Exception(
            "User with email ${event.receiverEmail} does not exist");
      }
      await sessionRepository.sendNannyConnectionRequest(
        sessionId: event.session.sessionId,
        senderId: event.senderId,
        senderEmail: event.senderEmail,
        receiverId: receiverId,
        startDate: event.session.startDate,
        endDate: event.session.endDate,
      );
      emit(NannyConnectionRequestSent());
    } catch (e) {
      emit(NannyConnectionsError(e.toString()));
    }
  }

  Future<void> _onLoadNannyConnectionRequests(LoadNannyConnectionRequests event,
      Emitter<NannyConnectionsManagementState> emit) async {
    emit(NannyConnectionsLoading());
    try {
      final requests =
          await sessionRepository.loadIncomingNannyRequests(event.userId);
      emit(NannyConnectionsLoaded(requests: requests));
    } catch (e) {
      emit(NannyConnectionsError(e.toString()));
    }
  }

  Future<void> _onAcceptNannyConnectionRequest(
    AcceptNannyConnectionRequest event,
    Emitter<NannyConnectionsManagementState> emit,
  ) async {
    try {
      await sessionRepository.acceptNannyConnectionRequest(event.requestId);

      final nannyConnection =
          await sessionRepository.getNannyConnectionRequest(event.requestId);
      final receiverId = nannyConnection.receiverId;
      final sessionId = nannyConnection.sessionId;
      final sessions = await sessionRepository.getSessions([sessionId]);
      if (sessions.isNotEmpty) {
        Session session = sessions.first;

        final updatedSession = session.copyWith(nannyId: receiverId);

        await sessionRepository.updateSession(updatedSession);

        emit(NannyConnectionRequestAccepted());
      } else {
        emit(NannyConnectionsError('Session $sessionId not found.'));
      }
    } catch (e) {
      emit(NannyConnectionsError(e.toString()));
    }
  }

  Future<void> _onDeclineNannyConnectionRequest(
      DeclineNannyConnectionRequest event,
      Emitter<NannyConnectionsManagementState> emit) async {
    try {
      await sessionRepository.declineNannyConnectionRequest(event.requestId);
      emit(NannyConnectionRequestDeclined());
    } catch (e) {
      emit(NannyConnectionsError(e.toString()));
    }
  }

  Future<void> _onUnlinkNannyConnection(UnlinkNannyConnection event,
      Emitter<NannyConnectionsManagementState> emit) async {
    try {
      await sessionRepository.unlinkNannyConnection(event.sessionId);
      emit(NannyConnectionUnlinked());
    } catch (e) {
      emit(NannyConnectionsError(e.toString()));
    }
  }
}