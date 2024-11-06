import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:connections_repository/connections_repository.dart';

class ConnectionsEntity extends Equatable {
  final String connectionId;
  final String connectionSenderId;
  final String senderEmail;
  final String connectionReceiverId;
  final String status;
  final DateTime requestTime;
  final DateTime updatedAt;

  const ConnectionsEntity({
    required this.connectionId,
    required this.connectionSenderId,
    required this.senderEmail,
    required this.connectionReceiverId,
    required this.status,
    required this.requestTime,
    required this.updatedAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'connectionId': connectionId,
      'connectionSenderId': connectionSenderId,
      'senderEmail': senderEmail,
      'connectionReceiverId': connectionReceiverId,
      'isComplstatuseted': status,
      'requestTime': Timestamp.fromDate(requestTime),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static ConnectionsEntity fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConnectionsEntity(
      connectionId: data['connectionId'] ?? '',
      connectionSenderId: data['connectionSenderId'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      connectionReceiverId: data['connectionReceiverId'] ?? '',
      status: data['status'] ?? '',
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Connections toModel() {
    return Connections(
      connectionId: connectionId,
      connectionSenderId: connectionSenderId,
      senderEmail: senderEmail,
      connectionReceiverId: connectionReceiverId,
      status: status,
      requestTime: requestTime,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        connectionId,
        connectionSenderId,
        senderEmail,
        connectionReceiverId,
        status,
        requestTime,
        updatedAt,
      ];
}
