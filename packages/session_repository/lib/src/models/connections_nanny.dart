import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class NannyConnections extends Equatable {
  final String connectionId;
  final String sessionId;
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime requestTime;
  final DateTime updatedAt;

  const NannyConnections({
    required this.connectionId,
    required this.sessionId,
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.requestTime,
    required this.updatedAt,
  });

  static final empty = NannyConnections(
    connectionId: '',
    sessionId: '',
    senderId: '',
    senderEmail: '',
    receiverId: '',
    status: '',
    startDate: DateTime(1970, 1, 1, 0, 0, 0),
    endDate: DateTime(1970, 1, 1, 0, 0, 0),
    requestTime: DateTime(1970, 1, 1, 0, 0, 0),
    updatedAt: DateTime(1970, 1, 1, 0, 0, 0),
  );

  NannyConnections copyWith({
    String? connectionId,
    String? sessionId,
    String? senderId,
    String? senderEmail,
    String? receiverId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? requestTime,
    DateTime? updatedAt,
  }) {
    return NannyConnections(
      connectionId: connectionId ?? this.connectionId,
      sessionId: sessionId ?? this.sessionId,
      senderId: senderId ?? this.senderId,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      requestTime: requestTime ?? this.requestTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  NannyConnectionsEntity toEntity() {
    return NannyConnectionsEntity(
      connectionId: connectionId,
      sessionId: sessionId,
      senderId: senderId,
      senderEmail: senderEmail,
      receiverId: receiverId,
      status: status,
      startDate: startDate,
      endDate: endDate,
      requestTime: requestTime,
      updatedAt: updatedAt,
    );
  }

  static NannyConnections fromEntity(NannyConnectionsEntity entity) {
    return NannyConnections(
      connectionId: entity.connectionId,
      sessionId: entity.sessionId,
      senderId: entity.senderId,
      senderEmail: entity.senderEmail,
      receiverId: entity.receiverId,
      status: entity.status,
      startDate: entity.startDate,
      endDate: entity.endDate,
      requestTime: entity.requestTime,
      updatedAt: entity.updatedAt,
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
        startDate,
        endDate,
        requestTime,
        updatedAt,
      ];
}
