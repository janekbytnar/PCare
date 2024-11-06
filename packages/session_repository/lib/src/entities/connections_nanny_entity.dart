import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class NannyConnectionsEntity extends Equatable {
  final String connectionId;
  final String sessionId;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String status;
  final DateTime requestTime;
  final DateTime updatedAt;

  const NannyConnectionsEntity({
    required this.connectionId,
    required this.sessionId,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.status,
    required this.requestTime,
    required this.updatedAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'connectionId': connectionId,
      'sessionId': sessionId,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'status': status,
      'requestTime': Timestamp.fromDate(requestTime),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static NannyConnectionsEntity fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NannyConnectionsEntity(
      connectionId: data['connectionId'] ?? '',
      sessionId: data['sessionId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: data['status'] ?? '',
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  NannyConnections toModel() {
    return NannyConnections(
      connectionId: connectionId,
      sessionId: sessionId,
      senderId: senderId,
      senderEmail: senderEmail,
      receiverId: receiverId,
      status: status,
      requestTime: requestTime,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        connectionId,
        sessionId,
        senderId,
        senderEmail,
        receiverId,
        status,
        requestTime,
        updatedAt,
      ];
}
