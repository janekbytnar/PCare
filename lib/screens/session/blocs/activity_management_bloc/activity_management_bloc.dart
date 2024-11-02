import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

part 'activity_management_event.dart';
part 'activity_management_state.dart';

class ActivityManagementBloc
    extends Bloc<ActivityManagementEvent, ActivityManagementState> {
  final SessionRepository sessionRepository;
  StreamSubscription<List<Activity>>? _activitiesSubscription;

  ActivityManagementBloc({required this.sessionRepository})
      : super(ActivityManagementLoading()) {
    on<LoadActivities>(_onLoadActivities);
    on<ActivityManagementUpdated>(_onActivitiesUpdated);
    on<ActivityManagementAdd>(_onAddActivity);
    on<ActivityManagementUpdate>(_onUpdateActivity);
    on<ActivityManagementDelete>(_onDeleteActivity);
  }
  void _onLoadActivities(
      LoadActivities event, Emitter<ActivityManagementState> emit) {
    _activitiesSubscription?.cancel();
    _activitiesSubscription =
        sessionRepository.getActivities(event.sessionId).listen(
      (activities) {
        add(ActivityManagementUpdated(activities, event.sessionId));
      },
      onError: (error) {
        emit(ActivityManagementError(error.toString()));
      },
    );
  }

  void _onActivitiesUpdated(
      ActivityManagementUpdated event, Emitter<ActivityManagementState> emit) {
    emit(ActivityManagementLoaded(event.activities));
  }

  void _onAddActivity(ActivityManagementAdd event,
      Emitter<ActivityManagementState> emit) async {
    await sessionRepository.addActivity(event.sessionId, event.activity);
  }

  void _onUpdateActivity(ActivityManagementUpdate event,
      Emitter<ActivityManagementState> emit) async {
    try {
      await sessionRepository.updateActivity(event.sessionId, event.activity);
    } catch (e) {
      emit(ActivityManagementError(e.toString()));
    }
  }

  void _onDeleteActivity(ActivityManagementDelete event,
      Emitter<ActivityManagementState> emit) async {
    try {
      await sessionRepository.deleteActivity(event.sessionId, event.activityId);
    } catch (e) {
      emit(ActivityManagementError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _activitiesSubscription?.cancel();
    return super.close();
  }
}
