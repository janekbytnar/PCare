import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String mealId;
  final String mealName;
  final String mealDescription;
  final DateTime mealTime;

  const MealEntity({
    required this.mealId,
    required this.mealName,
    required this.mealDescription,
    required this.mealTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'mealId': mealId,
      'mealName': mealName,
      'mealDescription': mealDescription,
      'mealTime': Timestamp.fromDate(mealTime),
    };
  }

  static MealEntity fromDocument(Map<String, dynamic> doc) {
    return MealEntity(
      mealId: doc['mealId'] ?? '',
      mealName: doc['mealName'] ?? '',
      mealDescription: doc['mealDescription'] ?? '',
      mealTime: (doc['mealTime'] as Timestamp).toDate(),
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
