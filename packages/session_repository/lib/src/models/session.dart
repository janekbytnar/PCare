import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Session extends Equatable {
  final String sessionId;
  final List<String> parentsId;
  final String sessionName;
  final String nannyId;
  final List<String> childsId;
  final DateTime startDate;
  final DateTime endDate;

  const Session({
    required this.sessionId,
    required this.parentsId,
    required this.sessionName,
    this.nannyId = '',
    required this.childsId,
    required this.startDate,
    required this.endDate,
  });

  static final empty = Session(
    sessionId: '',
    parentsId: const [],
    sessionName: '',
    nannyId: '',
    childsId: const [],
    startDate: DateTime(1970, 1, 1),
    endDate: DateTime(1970, 1, 1),
  );

  Session copyWith({
    String? sessionId,
    List<String>? parentsId,
    String? sessionName,
    String? nannyId,
    List<String>? childsId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      parentsId: parentsId ?? this.parentsId,
      sessionName: sessionName ?? this.sessionName,
      nannyId: nannyId ?? this.nannyId,
      childsId: childsId ?? this.childsId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  SessionEntity toEntity() {
    return SessionEntity(
      sessionId: sessionId,
      parentsId: parentsId,
      sessionName: sessionName,
      nannyId: nannyId,
      childsId: childsId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  static Session fromEntity(SessionEntity entity) {
    return Session(
      sessionId: entity.sessionId,
      parentsId: entity.parentsId,
      sessionName: entity.sessionName,
      nannyId: entity.nannyId,
      childsId: entity.childsId,
      startDate: entity.startDate,
      endDate: entity.endDate,
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        parentsId,
        sessionName,
        nannyId,
        childsId,
        startDate,
        endDate,
      ];
}
