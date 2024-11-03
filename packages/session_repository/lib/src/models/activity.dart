import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Activity extends Equatable {
  final String activityId;
  final String activityName;
  final String activityDescription;
  final bool isCompleted;
  final DateTime activityTime;

  const Activity({
    required this.activityId,
    required this.activityName,
    required this.activityDescription,
    required this.isCompleted,
    required this.activityTime,
  });

  static final empty = Activity(
    activityId: '',
    activityName: '',
    activityDescription: '',
    isCompleted: false,
    activityTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Activity copyWith({
    String? activityId,
    String? activityName,
    String? activityDescription,
    bool? isCompleted,
    DateTime? activityTime,
  }) {
    return Activity(
      activityId: activityId ?? this.activityId,
      activityName: activityName ?? this.activityName,
      activityDescription: activityDescription ?? this.activityDescription,
      isCompleted: isCompleted ?? this.isCompleted,
      activityTime: activityTime ?? this.activityTime,
    );
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      activityId: activityId,
      activityName: activityName,
      activityDescription: activityDescription,
      isCompleted: isCompleted,
      activityTime: activityTime,
    );
  }

  static Activity fromEntity(ActivityEntity entity) {
    return Activity(
      activityId: entity.activityId,
      activityName: entity.activityName,
      activityDescription: entity.activityDescription,
      isCompleted: entity.isCompleted,
      activityTime: entity.activityTime,
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
