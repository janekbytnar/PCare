part of 'nanny_connection_management_bloc.dart';

sealed class NannyConnectionsManagementEvent extends Equatable {
  const NannyConnectionsManagementEvent();

  @override
  List<Object?> get props => [];
}

class SendNannyConnectionRequest extends NannyConnectionsManagementEvent {
  final String sessionId;
  final String senderId;
  final String senderEmail;
  final String receiverEmail;

  const SendNannyConnectionRequest(
      this.senderId, this.sessionId, this.senderEmail, this.receiverEmail);

  @override
  List<Object?> get props => [senderId, sessionId, senderEmail, receiverEmail];
}

class LoadNannyConnectionRequests extends NannyConnectionsManagementEvent {
  final String userId;

  const LoadNannyConnectionRequests(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AcceptNannyConnectionRequest extends NannyConnectionsManagementEvent {
  final String requestId;

  const AcceptNannyConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class DeclineNannyConnectionRequest extends NannyConnectionsManagementEvent {
  final String requestId;

  const DeclineNannyConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class UnlinkNannyConnection extends NannyConnectionsManagementEvent {
  final String sessionId;

  const UnlinkNannyConnection(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}
