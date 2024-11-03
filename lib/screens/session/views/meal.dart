import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/add_dialog.dart';
import 'package:perfect_childcare/components/tile.dart';
import 'package:perfect_childcare/screens/session/blocs/meal_management_bloc/meal_management_bloc.dart';
import 'package:session_repository/session_repository.dart';

class MealScreen extends StatefulWidget {
  final List<Meal>? meal;
  final String sessionId;
  const MealScreen({super.key, this.meal, required this.sessionId});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(105.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/meals.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<MealManagementBloc, MealManagementState>(
        builder: (context, state) {
          if (state is MealManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MealManagementLoaded) {
            final meals = state.meals;
            if (meals.isEmpty) {
              return const Center(child: Text('No meals found.'));
            }
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return CustomTile(
                  title: meal.mealName,
                  done: meal.isCompleted,
                  subtitle: meal.mealDescription,
                  onToggleDone: () {
                    final updatedMeal = Meal(
                      mealId: meal.mealId,
                      mealName: meal.mealName,
                      mealDescription: meal.mealDescription,
                      isCompleted: !meal.isCompleted,
                      mealTime: meal.mealTime,
                    );
                    context.read<MealManagementBloc>().add(MealManagementUpdate(
                          updatedMeal,
                          widget.sessionId,
                        ));
                  },
                  onDelete: () {
                    context.read<MealManagementBloc>().add(MealManagementDelete(
                          meal.mealId,
                          widget.sessionId,
                        ));
                  },
                );
              },
            );
          } else if (state is MealManagementError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'mealsTag',
        backgroundColor: CupertinoColors.activeGreen,
        foregroundColor: CupertinoColors.systemGrey,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        tooltip: "Add meal",
        onPressed: () {
          _dialogBuilder(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddDialog(
          title: 'Meal',
          onAdd: (name, description) {
            final newMeal = Meal(
              mealId: '',
              mealName: name,
              mealDescription: description ?? "",
              isCompleted: false,
              mealTime: DateTime.now(),
            );
            context.read<MealManagementBloc>().add(
                  MealManagementAdd(newMeal, widget.sessionId),
                );
          },
        );
      },
    );
  }
}
