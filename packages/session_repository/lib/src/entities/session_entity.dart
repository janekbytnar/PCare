import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final List<String> parentsId;
  final String sessionName;
  final String nannyId;
  final List<String> childsId;
  final DateTime startDate;
  final DateTime endDate;

  const SessionEntity({
    required this.sessionId,
    required this.parentsId,
    required this.sessionName,
    required this.nannyId,
    required this.childsId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, Object?> toDocument() {
    return {
      'sessionId': sessionId,
      'parentsId': parentsId,
      'sessionName': sessionName,
      'nannyId': nannyId,
      'childsId': childsId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
    };
  }

  static SessionEntity fromDocument(DocumentSnapshot doc) {
    return SessionEntity(
      sessionId: doc['sessionId'] ?? '',
      parentsId: (doc['parentsId'] as List<dynamic>?)
              ?.map((parentId) => parentId as String)
              .toList() ??
          [],
      sessionName: doc['sessionName'] ?? '',
      nannyId: doc['nannyId'] ?? '',
      childsId: (doc['childsId'] as List<dynamic>?)
              ?.map((childId) => childId as String)
              .toList() ??
          [],
      startDate: (doc['startDate'] as Timestamp).toDate(),
      endDate: (doc['endDate'] as Timestamp).toDate(),
    );
  }

  Session toModel() {
    return Session(
      sessionId: sessionId,
      parentsId: parentsId,
      sessionName: sessionName,
      nannyId: nannyId,
      childsId: childsId,
      startDate: startDate,
      endDate: endDate,
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
