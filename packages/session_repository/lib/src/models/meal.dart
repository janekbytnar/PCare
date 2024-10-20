import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Meal extends Equatable {
  final String mealId;
  final String mealName;
  final String mealDescription;
  final DateTime mealTime;

  const Meal({
    required this.mealId,
    required this.mealName,
    required this.mealDescription,
    required this.mealTime,
  });

  static final empty = Meal(
    mealId: '',
    mealName: '',
    mealDescription: '',
    mealTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Meal copyWith({
    String? mealId,
    String? mealName,
    String? mealDescription,
    DateTime? mealTime,
  }) {
    return Meal(
      mealId: mealId ?? this.mealId,
      mealName: mealName ?? this.mealName,
      mealDescription: mealDescription ?? this.mealDescription,
      mealTime: mealTime ?? this.mealTime,
    );
  }

  MealEntity toEntity() {
    return MealEntity(
      mealId: mealId,
      mealName: mealName,
      mealDescription: mealDescription,
      mealTime: mealTime,
    );
  }

  static Meal fromEntity(MealEntity entity) {
    return Meal(
      mealId: entity.mealId,
      mealName: entity.mealName,
      mealDescription: entity.mealDescription,
      mealTime: entity.mealTime,
    );
  }

  @override
  List<Object?> get props => [
        mealId,
        mealName,
        mealDescription,
        mealTime,
      ];
}
