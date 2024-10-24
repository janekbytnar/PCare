import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Activity extends Equatable {
  final String activityId;
  final String activityName;
  final String activityDescription;
  final DateTime activityTime;

  const Activity({
    required this.activityId,
    required this.activityName,
    required this.activityDescription,
    required this.activityTime,
  });

  static final empty = Activity(
    activityId: '',
    activityName: '',
    activityDescription: '',
    activityTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Activity copyWith({
    String? activityId,
    String? activityName,
    String? activityDescription,
    DateTime? activityTime,
  }) {
    return Activity(
      activityId: activityId ?? this.activityId,
      activityName: activityName ?? this.activityName,
      activityDescription: activityDescription ?? this.activityDescription,
      activityTime: activityTime ?? this.activityTime,
    );
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      activityId: activityId,
      activityName: activityName,
      activityDescription: activityDescription,
      activityTime: activityTime,
    );
  }

  static Activity fromEntity(ActivityEntity entity) {
    return Activity(
      activityId: entity.activityId,
      activityName: entity.activityName,
      activityDescription: entity.activityDescription,
      activityTime: entity.activityTime,
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
