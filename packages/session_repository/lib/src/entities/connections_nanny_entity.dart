import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class NannyConnectionsEntity extends Equatable {
  final String connectionId;
  final String sessionId;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String receiverEmail;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime requestTime;
  final DateTime updatedAt;

  const NannyConnectionsEntity({
    required this.connectionId,
    required this.sessionId,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.receiverEmail,
    required this.status,
    required this.startDate,
    required this.endDate,
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
      'receiverEmail': receiverEmail,
      'status': status,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
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
      receiverEmail: data['receiverEmail'] ?? '',
      status: data['status'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
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
      receiverEmail: receiverEmail,
      status: status,
      startDate: startDate,
      endDate: endDate,
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
        receiverEmail,
        status,
        startDate,
        endDate,
        requestTime,
        updatedAt,
      ];
}
