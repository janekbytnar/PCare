import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'entities.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ActivityEntity> activities;
  final List<MealEntity> meals;
  final List<ObservationEntity> observations;

  const SessionEntity({
    required this.sessionId,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.observations = const [],
  });

  Map<String, Object?> toDocument() {
    return {
      'sessionId': sessionId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'activities':
          activities.map((activity) => activity.toDocument()).toList(),
      'meals': meals.map((meal) => meal.toDocument()).toList(),
      'observations':
          observations.map((observation) => observation.toDocument()).toList(),
    };
  }

  static SessionEntity fromDocument(Map<String, dynamic> doc) {
    return SessionEntity(
      sessionId: doc['sessionId'] ?? '',
      startDate: (doc['startDate'] as Timestamp).toDate(),
      endDate: (doc['endDate'] as Timestamp).toDate(),
      activities: (doc['activities'] as List<dynamic>?)
              ?.map((activityData) => ActivityEntity.fromDocument(
                  activityData as Map<String, dynamic>))
              .toList() ??
          [],
      meals: (doc['meals'] as List<dynamic>?)
              ?.map((mealData) =>
                  MealEntity.fromDocument(mealData as Map<String, dynamic>))
              .toList() ??
          [],
      observations: (doc['observations'] as List<dynamic>?)
              ?.map((observationData) => ObservationEntity.fromDocument(
                  observationData as Map<String, dynamic>))
              .toList() ??
          [],
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
