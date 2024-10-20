import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ObservationEntity extends Equatable {
  final String observationId;
  final String observationName;
  final String observationDescription;
  final DateTime observationTime;

  const ObservationEntity({
    required this.observationId,
    required this.observationName,
    required this.observationDescription,
    required this.observationTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'observationId': observationId,
      'observationName': observationName,
      'observationDescription': observationDescription,
      'observationTime': Timestamp.fromDate(observationTime),
    };
  }

  static ObservationEntity fromDocument(Map<String, dynamic> doc) {
    return ObservationEntity(
      observationId: doc['observationId'] ?? '',
      observationName: doc['observationName'] ?? '',
      observationDescription: doc['observationDescription'] ?? '',
      observationTime: (doc['observationTime'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        observationId,
        observationName,
        observationDescription,
        observationTime,
      ];
}
