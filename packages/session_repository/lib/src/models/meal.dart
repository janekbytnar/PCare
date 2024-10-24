import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Meal extends Equatable {
  final String mealId;
  final String mealName;
  final String mealDescription;
  final bool isCompleted;
  final DateTime mealTime;

  const Meal({
    required this.mealId,
    required this.mealName,
    required this.mealDescription,
    required this.isCompleted,
    required this.mealTime,
  });

  static final empty = Meal(
    mealId: '',
    mealName: '',
    mealDescription: '',
    isCompleted: false,
    mealTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Meal copyWith({
    String? mealId,
    String? mealName,
    String? mealDescription,
    bool? isCompleted,
    DateTime? mealTime,
  }) {
    return Meal(
      mealId: mealId ?? this.mealId,
      mealName: mealName ?? this.mealName,
      mealDescription: mealDescription ?? this.mealDescription,
      isCompleted: isCompleted ?? this.isCompleted,
      mealTime: mealTime ?? this.mealTime,
    );
  }

  MealEntity toEntity() {
    return MealEntity(
      mealId: mealId,
      mealName: mealName,
      mealDescription: mealDescription,
      isCompleted: isCompleted,
      mealTime: mealTime,
    );
  }

  static Meal fromEntity(MealEntity entity) {
    return Meal(
      mealId: entity.mealId,
      mealName: entity.mealName,
      mealDescription: entity.mealDescription,
      isCompleted: entity.isCompleted,
      mealTime: entity.mealTime,
    );
  }

  @override
  List<Object?> get props => [
        mealId,
        mealName,
        mealDescription,
        isCompleted,
        mealTime,
      ];
}
