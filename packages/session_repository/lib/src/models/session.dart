import 'package:equatable/equatable.dart';
import '../entities/entities.dart';
import 'models.dart';

class Session extends Equatable {
  final String sessionId;
  final DateTime startDate;
  final DateTime endDate;
  final List<Activity> activities;
  final List<Meal> meals;
  final List<Observation> observations;

  const Session({
    required this.sessionId,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.observations = const [],
  });

  static final empty = Session(
    sessionId: '',
    startDate: DateTime(1970, 1, 1),
    endDate: DateTime(1970, 1, 1),
    activities: const [],
    meals: const [],
    observations: const [],
  );

  Session copyWith({
    String? sessionId,
    DateTime? startDate,
    DateTime? endDate,
    List<Activity>? activities,
    List<Meal>? meals,
    List<Observation>? observations,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activities: activities ?? this.activities,
      meals: meals ?? this.meals,
      observations: observations ?? this.observations,
    );
  }

  SessionEntity toEntity() {
    return SessionEntity(
      sessionId: sessionId,
      startDate: startDate,
      endDate: endDate,
      activities: activities.map((activity) => activity.toEntity()).toList(),
      meals: meals.map((meal) => meal.toEntity()).toList(),
      observations:
          observations.map((observation) => observation.toEntity()).toList(),
    );
  }

  static Session fromEntity(SessionEntity entity) {
    return Session(
      sessionId: entity.sessionId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      activities: entity.activities
          .map((activityEntity) => Activity.fromEntity(activityEntity))
          .toList(),
      meals: entity.meals
          .map((mealEntity) => Meal.fromEntity(mealEntity))
          .toList(),
      observations: entity.observations
          .map((observationEntity) => Observation.fromEntity(observationEntity))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        startDate,
        endDate,
        activities,
        meals,
        observations,
      ];
}
