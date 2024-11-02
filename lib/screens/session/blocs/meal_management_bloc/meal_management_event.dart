part of 'meal_management_bloc.dart';

sealed class MealManagementEvent extends Equatable {
  const MealManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeals extends MealManagementEvent {
  final String sessionId;

  const LoadMeals(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class MealManagementUpdated extends MealManagementEvent {
  final List<Meal> meals;
  final String sessionId;

  const MealManagementUpdated(this.meals, this.sessionId);

  @override
  List<Object?> get props => [meals];
}

class MealManagementAdd extends MealManagementEvent {
  final Meal meal;
  final String sessionId;

  const MealManagementAdd(this.meal, this.sessionId);

  @override
  List<Object?> get props => [meal];
}

class MealManagementUpdate extends MealManagementEvent {
  final Meal meal;
  final String sessionId;

  const MealManagementUpdate(this.meal, this.sessionId);

  @override
  List<Object?> get props => [meal];
}

class MealManagementDelete extends MealManagementEvent {
  final String mealId;
  final String sessionId;

  const MealManagementDelete(this.mealId, this.sessionId);

  @override
  List<Object?> get props => [mealId];
}
