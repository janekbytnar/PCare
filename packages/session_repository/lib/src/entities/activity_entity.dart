import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

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

  static ActivityEntity fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityEntity(
      activityId: data['activityId'] ?? '',
      activityName: data['activityName'] ?? '',
      activityDescription: data['activityDescription'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      activityTime: (data['activityTime'] as Timestamp).toDate(),
    );
  }

  Activity toModel() {
    return Activity(
      activityId: activityId,
      activityName: activityName,
      activityDescription: activityDescription,
      isCompleted: isCompleted,
      activityTime: activityTime,
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
