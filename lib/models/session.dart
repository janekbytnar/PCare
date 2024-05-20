import 'package:perfect_childcare/models/activity.dart';
import 'package:perfect_childcare/models/child.dart';
import 'package:perfect_childcare/models/meal.dart';
import 'package:perfect_childcare/models/observation.dart';

class Session {
  final DateTime? planedStartAt;
  final DateTime? planedEndAt;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? createdAt;
  final List<Child>? childrens;
  final List<Meal>? meals;
  final List<Activity>? activities;
  final List<Observation>? observations;
  final String? nannyUid;
  final String? parentUid;

  Session({
    this.planedStartAt,
    this.planedEndAt,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.childrens,
    this.nannyUid,
    this.parentUid,
    this.meals,
    this.activities,
    this.observations,
  });

  Map<String, dynamic> toMap() {
    return {
      'planedStartAt': planedStartAt?.toIso8601String(),
      'planedEndAt': planedEndAt?.toIso8601String(),
      'startAt': startAt?.toIso8601String(),
      'endAt': endAt?.toIso8601String(),
      'childrens': childrens
          ?.map((child) => child.toMap())
          .toList(), // Conversion child/s for List
      'meals': meals
          ?.map((meal) => meal.toMap())
          .toList(), // Conversion meal/s for List
      'activities': activities
          ?.map((activity) => activity.toMap())
          .toList(), // Conversion activity/ies for List
      'observations':
          observations?.map((observation) => observation.toMap()).toList(),
      'nannyUid': nannyUid,
      'parentUid': parentUid,
    };
  }
}
