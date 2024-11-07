part of 'connections_management_bloc.dart';

abstract class ConnectionsManagementEvent extends Equatable {
  const ConnectionsManagementEvent();

  @override
  List<Object?> get props => [];
}

class SendConnectionRequest extends ConnectionsManagementEvent {
  final String senderId;
  final String senderEmail;
  final String receiverEmail;

  const SendConnectionRequest(
      this.senderId, this.senderEmail, this.receiverEmail);

  @override
  List<Object?> get props => [senderId, senderEmail, receiverEmail];
}

class LoadConnectionRequests extends ConnectionsManagementEvent {
  final String userId;

  const LoadConnectionRequests(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AcceptConnectionRequest extends ConnectionsManagementEvent {
  final String requestId;

  const AcceptConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class DeclineConnectionRequest extends ConnectionsManagementEvent {
  final String requestId;

  const DeclineConnectionRequest(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class UnlinkConnection extends ConnectionsManagementEvent {
  final String userId;
  final String linkedPersonId;

  const UnlinkConnection(this.userId, this.linkedPersonId);

  @override
  List<Object?> get props => [userId, linkedPersonId];
}
