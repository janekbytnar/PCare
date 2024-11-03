part of 'activity_management_bloc.dart';

sealed class ActivityManagementState extends Equatable {
  const ActivityManagementState();

  @override
  List<Object?> get props => [];
}

final class ActivityManagementLoading extends ActivityManagementState {}

class ActivityManagementLoaded extends ActivityManagementState {
  final List<Activity> activities;

  const ActivityManagementLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivityManagementError extends ActivityManagementState {
  final String error;

  const ActivityManagementError(this.error);

  @override
  List<Object?> get props => [error];
}
