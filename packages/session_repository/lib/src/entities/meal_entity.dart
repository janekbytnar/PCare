import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class MealEntity extends Equatable {
  final String mealId;
  final String mealName;
  final String mealDescription;
  final bool isCompleted;
  final DateTime mealTime;

  const MealEntity({
    required this.mealId,
    required this.mealName,
    required this.mealDescription,
    required this.isCompleted,
    required this.mealTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'mealId': mealId,
      'mealName': mealName,
      'mealDescription': mealDescription,
      'isCompleted': isCompleted,
      'mealTime': Timestamp.fromDate(mealTime),
    };
  }

  static MealEntity fromDocument(Map<String, dynamic> doc) {
    return MealEntity(
      mealId: doc['mealId'] ?? '',
      mealName: doc['mealName'] ?? '',
      mealDescription: doc['mealDescription'] ?? '',
      isCompleted: doc['isCompleted'] ?? false,
      mealTime: (doc['mealTime'] as Timestamp).toDate(),
    );
  }

  Meal toModel() {
    return Meal(
      mealId: mealId,
      mealName: mealName,
      mealDescription: mealDescription,
      isCompleted: isCompleted,
      mealTime: mealTime,
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
