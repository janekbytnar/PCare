import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class SessionEntity extends Equatable {
  final String sessionId;
  final List<String> parentsId;
  final String nannyId;
  final List<String> childsId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ActivityEntity> activities;
  final List<MealEntity> meals;
  final List<NoteEntity> notes;

  const SessionEntity({
    required this.sessionId,
    required this.parentsId,
    required this.nannyId,
    required this.childsId,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.notes = const [],
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
      'notes': notes.map((note) => note.toDocument()).toList(),
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
                  activityData as DocumentSnapshot<Object?>))
              .toList() ??
          [],
      meals: (doc['meals'] as List<dynamic>?)
              ?.map((mealData) => MealEntity.fromDocument(
                  mealData as DocumentSnapshot<Object?>))
              .toList() ??
          [],
      notes: (doc['notes'] as List<dynamic>?)
              ?.map((noteData) => NoteEntity.fromDocument(
                  noteData as DocumentSnapshot<Object?>))
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
      notes: notes.map((note) => note.toModel()).toList(),
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
        notes,
      ];
}
