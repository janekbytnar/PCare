import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';
import 'package:connections_repository/connections_repository.dart';

part 'connections_management_event.dart';
part 'connections_management_state.dart';

class ConnectionsManagementBloc
    extends Bloc<ConnectionsManagementEvent, ConnectionsManagementState> {
  final UserRepository userRepository;
  final ConnectionsRepository connectionsRepository;

  ConnectionsManagementBloc({
    required this.userRepository,
    required this.connectionsRepository,
  }) : super(ConnectionsInitial()) {
    on<SendConnectionRequest>(_onSendConnectionRequest);
    on<LoadConnectionRequests>(_onLoadConnectionRequests);
    on<AcceptConnectionRequest>(_onAcceptConnectionRequest);
    on<DeclineConnectionRequest>(_onDeclineConnectionRequest);
    on<UnlinkConnection>(_onUnlinkConnection);
  }

  Future<void> _onSendConnectionRequest(SendConnectionRequest event,
      Emitter<ConnectionsManagementState> emit) async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(const ConnectionsError('User not logged in'));
      return;
    }
    emit(ConnectionsLoading());
    final normalizedReceiverEmail = event.receiverEmail.toLowerCase();
    final normalizedSenderEmail = event.senderEmail.toLowerCase();
    try {
      final results = await userRepository
          .getUserIdAndNannyStatusByEmail(normalizedReceiverEmail);

      if (results == null) {
        throw Exception(
            "User with email ${event.receiverEmail} does not exist");
      }
      final receiverId = results[0].toString();
      await connectionsRepository.sendConnectionRequest(
        senderId: event.senderId,
        receiverId: receiverId,
        senderEmail: normalizedSenderEmail,
      );
      emit(ConnectionRequestSent());
    } catch (e) {
      emit(ConnectionsError(e.toString()));
    }
  }

  Future<void> _onLoadConnectionRequests(LoadConnectionRequests event,
      Emitter<ConnectionsManagementState> emit) async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(const ConnectionsError('User not logged in'));
      return;
    }
    emit(ConnectionsLoading());
    try {
      final requests =
          await connectionsRepository.loadIncomingRequests(event.userId);
      emit(ConnectionsLoaded(requests: requests));
    } catch (e) {
      emit(ConnectionsError(e.toString()));
    }
  }

  Future<void> _onAcceptConnectionRequest(
    AcceptConnectionRequest event,
    Emitter<ConnectionsManagementState> emit,
  ) async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(const ConnectionsError('User not logged in'));
      return;
    }
    try {
      await connectionsRepository.acceptConnectionRequest(event.requestId);

      final connection =
          await connectionsRepository.getConnectionRequest(event.requestId);

      final senderId = connection.connectionSenderId;
      final receiverId = connection.connectionReceiverId;
      await userRepository.addLinkedPerson(senderId, receiverId);

      emit(ConnectionRequestAccepted());
    } catch (e) {
      emit(ConnectionsError(e.toString()));
    }
  }

  Future<void> _onDeclineConnectionRequest(DeclineConnectionRequest event,
      Emitter<ConnectionsManagementState> emit) async {
    if (FirebaseAuth.instance.currentUser == null) {
      emit(const ConnectionsError('User not logged in'));
      return;
    }
    try {
      await connectionsRepository.declineConnectionRequest(event.requestId);
      emit(ConnectionRequestDeclined());
    } catch (e) {
      emit(ConnectionsError(e.toString()));
    }
  }

  Future<void> _onUnlinkConnection(
      UnlinkConnection event, Emitter<ConnectionsManagementState> emit) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const ConnectionsError('User not logged in'));
        return;
      }
      await connectionsRepository.unlinkConnection(
          event.userId, event.linkedPersonId);
      await userRepository.unlinkPerson(event.userId, event.linkedPersonId);
      emit(ConnectionUnlinked());
    } catch (e) {
      emit(ConnectionsError(e.toString()));
    }
  }
}
