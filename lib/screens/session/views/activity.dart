import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/add_dialog.dart';
import 'package:perfect_childcare/components/tile.dart';
import 'package:perfect_childcare/screens/session/blocs/activity_management_bloc/activity_management_bloc.dart';
import 'package:session_repository/session_repository.dart';

class ActivityScreen extends StatefulWidget {
  final List<Activity>? activity;
  final String sessionId;
  const ActivityScreen({super.key, this.activity, required this.sessionId});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(105.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/activity.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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
                  },
                  onDelete: () {
                    context
                        .read<ActivityManagementBloc>()
                        .add(ActivityManagementDelete(
                          activity.activityId,
                          widget.sessionId,
                        ));
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
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddDialog(
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
