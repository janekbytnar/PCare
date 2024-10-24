import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String activityId;
  final String activityName;
  final String activityDescription;
  final bool isCompleted;
  final DateTime activityTime;

  const ActivityEntity({
    required this.activityId,
    required this.activityName,
    required this.activityDescription,
    required this.isCompleted,
    required this.activityTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'activityId': activityId,
      'activityName': activityName,
      'activityDescription': activityDescription,
      'isCompleted': isCompleted,
      'activityTime': Timestamp.fromDate(activityTime),
    };
  }

  static ActivityEntity fromDocument(Map<String, dynamic> doc) {
    return ActivityEntity(
      activityId: doc['activityId'] ?? '',
      activityName: doc['activityName'] ?? '',
      activityDescription: doc['activityDescription'] ?? '',
      isCompleted: doc['isCompleted'] ?? false,
      activityTime: (doc['activityTime'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        activityId,
        activityName,
        activityDescription,
        isCompleted,
        activityTime,
      ];
}
