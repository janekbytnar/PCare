part of 'meal_management_bloc.dart';

sealed class MealManagementState extends Equatable {
  const MealManagementState();

  @override
  List<Object?> get props => [];
}

final class MealManagementLoading extends MealManagementState {}

class MealManagementLoaded extends MealManagementState {
  final List<Meal> meals;

  const MealManagementLoaded(this.meals);

  @override
  List<Object?> get props => [meals];
}

class MealManagementError extends MealManagementState {
  final String error;

  const MealManagementError(this.error);

  @override
  List<Object?> get props => [error];
}
