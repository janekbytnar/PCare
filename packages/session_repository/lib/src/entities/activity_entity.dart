import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String activityId;
  final String activityName;
  final String activityDescription;
  final DateTime activityTime;

  const ActivityEntity({
    required this.activityId,
    required this.activityName,
    required this.activityDescription,
    required this.activityTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'activityId': activityId,
      'activityName': activityName,
      'activityDescription': activityDescription,
      'activityTime': Timestamp.fromDate(activityTime),
    };
  }

  static ActivityEntity fromDocument(Map<String, dynamic> doc) {
    return ActivityEntity(
      activityId: doc['activityId'] ?? '',
      activityName: doc['activityName'] ?? '',
      activityDescription: doc['activityDescription'] ?? '',
      activityTime: (doc['activityTime'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [
        activityId,
        activityName,
        activityDescription,
        activityTime,
      ];
}
