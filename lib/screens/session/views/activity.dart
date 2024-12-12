import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/add_dialog.dart';
import 'package:perfect_childcare/components/tile.dart';
import 'package:perfect_childcare/screens/session/blocs/activity_management_bloc/activity_management_bloc.dart';
import 'package:session_repository/session_repository.dart';

class ActivityScreen extends StatefulWidget {
  final String sessionId;
  final DateTime endDate;
  const ActivityScreen(
      {super.key, required this.sessionId, required this.endDate});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Activity',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeBlue,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocBuilder<ActivityManagementBloc, ActivityManagementState>(
        builder: (context, state) {
          if (state is ActivityManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ActivityManagementLoaded) {
            final activities = state.activities;
            if (activities.isEmpty) {
              return const Center(child: Text('No activities found.'));
            }
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return CustomTile(
                  title: activity.activityName,
                  done: activity.isCompleted,
                  subtitle: activity.activityDescription,
                  onToggleDone: () {
                    final currentTime = DateTime.now();
                    if (currentTime.isBefore(widget.endDate)) {
                      final updatedActivity = Activity(
                        activityId: activity.activityId,
                        activityName: activity.activityName,
                        activityDescription: activity.activityDescription,
                        isCompleted: !activity.isCompleted,
                        activityTime: activity.activityTime,
                      );
                      context
                          .read<ActivityManagementBloc>()
                          .add(ActivityManagementUpdate(
                            updatedActivity,
                            widget.sessionId,
                          ));
                    }
                    // do nothing when currenttime > endtime
                  },
                  onDelete: () {
                    final currentTime = DateTime.now();
                    if (currentTime.isBefore(widget.endDate)) {
                      context
                          .read<ActivityManagementBloc>()
                          .add(ActivityManagementDelete(
                            activity.activityId,
                            widget.sessionId,
                          ));
                    }
                  },
                );
              },
            );
          } else if (state is ActivityManagementError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: (widget.endDate.isAfter(DateTime.now()))
          ? FloatingActionButton(
              heroTag: 'acitivityTag',
              backgroundColor: CupertinoColors.activeBlue,
              foregroundColor: CupertinoColors.systemGrey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tooltip: "Add action",
              onPressed: () {
                _dialogBuilder(context);
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return MyAddDialog(
          title: 'Activity',
          onAdd: (name, description) {
            final newActivity = Activity(
              activityId: '',
              activityName: name,
              activityDescription: description ?? "",
              isCompleted: false,
              activityTime: DateTime.now(),
            );
            context.read<ActivityManagementBloc>().add(
                  ActivityManagementAdd(newActivity, widget.sessionId),
                );
          },
        );
      },
    );
  }
}
