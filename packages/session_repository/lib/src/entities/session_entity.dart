import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';
import 'entities.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final List<String> parentsId;
  final String nannyId;
  final List<String> childsId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ActivityEntity> activities;
  final List<MealEntity> meals;
  final List<ObservationEntity> observations;

  const SessionEntity({
    required this.sessionId,
    required this.parentsId,
    required this.nannyId,
    required this.childsId,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.observations = const [],
  });

  Map<String, Object?> toDocument() {
    return {
      'sessionId': sessionId,
      'parentsId': parentsId,
      'nannyId': nannyId,
      'childsId': childsId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'activities':
          activities.map((activity) => activity.toDocument()).toList(),
      'meals': meals.map((meal) => meal.toDocument()).toList(),
      'observations':
          observations.map((observation) => observation.toDocument()).toList(),
    };
  }

  static SessionEntity fromDocument(DocumentSnapshot doc) {
    return SessionEntity(
      sessionId: doc['sessionId'] ?? '',
      parentsId: (doc['parentsId'] as List<dynamic>?)
              ?.map((parentId) => parentId as String)
              .toList() ??
          [],
      nannyId: doc['nannyId'] ?? '',
      childsId: (doc['childsId'] as List<dynamic>?)
              ?.map((childId) => childId as String)
              .toList() ??
          [],
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

  Session toModel() {
    return Session(
      sessionId: sessionId,
      parentsId: parentsId,
      nannyId: nannyId,
      childsId: childsId,
      startDate: startDate,
      endDate: endDate,
      activities: activities.map((activity) => activity.toModel()).toList(),
      meals: meals.map((meal) => meal.toModel()).toList(),
      observations:
          observations.map((observation) => observation.toModel()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        sessionId,
        parentsId,
        nannyId,
        childsId,
        startDate,
        endDate,
        activities,
        meals,
        observations,
      ];
}
