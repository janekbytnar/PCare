import 'package:equatable/equatable.dart';
import '../entities/entities.dart';
import 'models.dart';

class Session extends Equatable {
  final String sessionId;
  final List<String> parentId;
  final String nannyId;
  final List<String> childIds;
  final DateTime startDate;
  final DateTime endDate;
  final List<Activity> activities;
  final List<Meal> meals;
  final List<Observation> observations;

  const Session({
    required this.sessionId,
    required this.parentId,
    required this.nannyId,
    required this.childIds,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.observations = const [],
  });

  static final empty = Session(
    sessionId: '',
    parentId: const [],
    nannyId: '',
    childIds: const [],
    startDate: DateTime(1970, 1, 1),
    endDate: DateTime(1970, 1, 1),
    activities: const [],
    meals: const [],
    observations: const [],
  );

  Session copyWith({
    String? sessionId,
    List<String>? parentId,
    String? nannyId,
    List<String>? childIds,
    DateTime? startDate,
    DateTime? endDate,
    List<Activity>? activities,
    List<Meal>? meals,
    List<Observation>? observations,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      parentId: parentId ?? this.parentId,
      nannyId: nannyId ?? this.nannyId,
      childIds: childIds ?? this.childIds,
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
      parentId: parentId,
      nannyId: nannyId,
      childIds: childIds,
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
      parentId: entity.parentId,
      nannyId: entity.nannyId,
      childIds: entity.childIds,
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
        parentId,
        nannyId,
        childIds,
        startDate,
        endDate,
        activities,
        meals,
        observations,
      ];
}
