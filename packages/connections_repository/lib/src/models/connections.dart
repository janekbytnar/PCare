import 'package:connections_repository/src/entities/connections_entity.dart';
import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Connections extends Equatable {
  final String connectionId;
  final String connectionSenderId;
  final String connectionReceiverId;
  final String status;
  final DateTime requestTime;
  final DateTime updatedAt;

  const Connections({
    required this.connectionId,
    required this.connectionSenderId,
    required this.connectionReceiverId,
    required this.status,
    required this.requestTime,
    required this.updatedAt,
  });

  static final empty = Connections(
    connectionId: '',
    connectionSenderId: '',
    connectionReceiverId: '',
    status: '',
    requestTime: DateTime(1970, 1, 1, 0, 0, 0),
    updatedAt: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Connections copyWith({
    String? connectionId,
    String? connectionSenderId,
    String? connectionReceiverId,
    String? status,
    DateTime? requestTime,
    DateTime? updatedAt,
  }) {
    return Connections(
      connectionId: connectionId ?? this.connectionId,
      connectionSenderId: connectionSenderId ?? this.connectionSenderId,
      connectionReceiverId: connectionReceiverId ?? this.connectionReceiverId,
      status: status ?? this.status,
      requestTime: requestTime ?? this.requestTime,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ConnectionsEntity toEntity() {
    return ConnectionsEntity(
      connectionId: connectionId,
      connectionSenderId: connectionSenderId,
      connectionReceiverId: connectionReceiverId,
      status: status,
      requestTime: requestTime,
      updatedAt: updatedAt,
    );
  }

  static Connections fromEntity(ConnectionsEntity entity) {
    return Connections(
      connectionId: entity.connectionId,
      connectionSenderId: entity.connectionSenderId,
      connectionReceiverId: entity.connectionReceiverId,
      status: entity.status,
      requestTime: entity.requestTime,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        connectionId,
        connectionSenderId,
        connectionReceiverId,
        status,
        requestTime,
        updatedAt,
      ];
}
