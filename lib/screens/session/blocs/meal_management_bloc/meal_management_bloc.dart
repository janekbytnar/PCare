import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

part 'meal_management_event.dart';
part 'meal_management_state.dart';

class MealManagementBloc
    extends Bloc<MealManagementEvent, MealManagementState> {
  final SessionRepository sessionRepository;
  StreamSubscription<List<Meal>>? _mealsSubscription;

  MealManagementBloc({required this.sessionRepository})
      : super(MealManagementLoading()) {
    on<LoadMeals>(_onLoadMeals);
    on<MealManagementUpdated>(_onMealsUpdated);
    on<MealManagementAdd>(_onAddMeal);
    on<MealManagementUpdate>(_onUpdateMeal);
    on<MealManagementDelete>(_onDeleteMeal);
  }
  void _onLoadMeals(LoadMeals event, Emitter<MealManagementState> emit) {
    _mealsSubscription?.cancel();
    _mealsSubscription = sessionRepository.getMeals(event.sessionId).listen(
      (meals) {
        add(MealManagementUpdated(meals, event.sessionId));
      },
      onError: (error) {
        emit(MealManagementError(error.toString()));
      },
    );
  }

  void _onMealsUpdated(
      MealManagementUpdated event, Emitter<MealManagementState> emit) {
    emit(MealManagementLoaded(event.meals));
  }

  void _onAddMeal(
      MealManagementAdd event, Emitter<MealManagementState> emit) async {
    await sessionRepository.addMeal(event.sessionId, event.meal);
  }

  void _onUpdateMeal(
      MealManagementUpdate event, Emitter<MealManagementState> emit) async {
    try {
      await sessionRepository.updateMeal(event.sessionId, event.meal);
    } catch (e) {
      emit(MealManagementError(e.toString()));
    }
  }

  void _onDeleteMeal(
      MealManagementDelete event, Emitter<MealManagementState> emit) async {
    try {
      await sessionRepository.deleteMeal(event.sessionId, event.mealId);
    } catch (e) {
      emit(MealManagementError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _mealsSubscription?.cancel();
    return super.close();
  }
}
