import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Observation extends Equatable {
  final String observationId;
  final String observationName;
  final String observationDescription;
  final DateTime observationTime;

  const Observation({
    required this.observationId,
    required this.observationName,
    required this.observationDescription,
    required this.observationTime,
  });

  static final empty = Observation(
    observationId: '',
    observationName: '',
    observationDescription: '',
    observationTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Observation copyWith({
    String? observationId,
    String? observationName,
    String? observationDescription,
    DateTime? observationTime,
  }) {
    return Observation(
      observationId: observationId ?? this.observationId,
      observationName: observationName ?? this.observationName,
      observationDescription:
          observationDescription ?? this.observationDescription,
      observationTime: observationTime ?? this.observationTime,
    );
  }

  ObservationEntity toEntity() {
    return ObservationEntity(
      observationId: observationId,
      observationName: observationName,
      observationDescription: observationDescription,
      observationTime: observationTime,
    );
  }

  static Observation fromEntity(ObservationEntity entity) {
    return Observation(
      observationId: entity.observationId,
      observationName: entity.observationName,
      observationDescription: entity.observationDescription,
      observationTime: entity.observationTime,
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
