import 'package:equatable/equatable.dart';
import '../entities/entities.dart';
import 'models.dart';

class Session extends Equatable {
  final String sessionId;
  final List<String> parentsId;
  final String nannyId;
  final List<String> childsId;
  final DateTime startDate;
  final DateTime endDate;
  final List<Activity> activities;
  final List<Meal> meals;
  final List<Note> notes;

  const Session({
    required this.sessionId,
    required this.parentsId,
    this.nannyId = '',
    required this.childsId,
    required this.startDate,
    required this.endDate,
    this.activities = const [],
    this.meals = const [],
    this.notes = const [],
  });

  static final empty = Session(
    sessionId: '',
    parentsId: const [],
    nannyId: '',
    childsId: const [],
    startDate: DateTime(1970, 1, 1),
    endDate: DateTime(1970, 1, 1),
    activities: const [],
    meals: const [],
    notes: const [],
  );

  Session copyWith({
    String? sessionId,
    List<String>? parentsId,
    String? nannyId,
    List<String>? childsId,
    DateTime? startDate,
    DateTime? endDate,
    List<Activity>? activities,
    List<Meal>? meals,
    List<Note>? observations,
  }) {
    return Session(
      sessionId: sessionId ?? this.sessionId,
      parentsId: parentsId ?? this.parentsId,
      nannyId: nannyId ?? this.nannyId,
      childsId: childsId ?? this.childsId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      activities: activities ?? this.activities,
      meals: meals ?? this.meals,
      notes: observations ?? this.notes,
    );
  }

  SessionEntity toEntity() {
    return SessionEntity(
      sessionId: sessionId,
      parentsId: parentsId,
      nannyId: nannyId,
      childsId: childsId,
      startDate: startDate,
      endDate: endDate,
      activities: activities.map((activity) => activity.toEntity()).toList(),
      meals: meals.map((meal) => meal.toEntity()).toList(),
      notes: notes.map((note) => note.toEntity()).toList(),
    );
  }

  static Session fromEntity(SessionEntity entity) {
    return Session(
      sessionId: entity.sessionId,
      parentsId: entity.parentsId,
      nannyId: entity.nannyId,
      childsId: entity.childsId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      activities: entity.activities
          .map((activityEntity) => Activity.fromEntity(activityEntity))
          .toList(),
      meals: entity.meals
          .map((mealEntity) => Meal.fromEntity(mealEntity))
          .toList(),
      notes: entity.notes
          .map((noteEntity) => Note.fromEntity(noteEntity))
          .toList(),
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
