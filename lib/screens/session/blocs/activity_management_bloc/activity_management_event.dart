part of 'activity_management_bloc.dart';

sealed class ActivityManagementEvent extends Equatable {
  const ActivityManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivities extends ActivityManagementEvent {
  final String sessionId;

  const LoadActivities(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class ActivityManagementUpdated extends ActivityManagementEvent {
  final List<Activity> activities;
  final String sessionId;

  const ActivityManagementUpdated(this.activities, this.sessionId);

  @override
  List<Object?> get props => [activities];
}

class ActivityManagementAdd extends ActivityManagementEvent {
  final Activity activity;
  final String sessionId;

  const ActivityManagementAdd(this.activity, this.sessionId);

  @override
  List<Object?> get props => [activity];
}

class ActivityManagementUpdate extends ActivityManagementEvent {
  final Activity activity;
  final String sessionId;

  const ActivityManagementUpdate(this.activity, this.sessionId);

  @override
  List<Object?> get props => [activity];
}

class ActivityManagementDelete extends ActivityManagementEvent {
  final String activityId;
  final String sessionId;

  const ActivityManagementDelete(this.activityId, this.sessionId);

  @override
  List<Object?> get props => [activityId];
}
