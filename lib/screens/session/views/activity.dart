import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfect_childcare/components/add_dialog.dart';
import 'package:perfect_childcare/components/tile.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<TileActivity> _activities = [
    const TileActivity(
      title: 'Read Boook',
      done: false,
      subtitle: 'Whatever you want',
    ),
    const TileActivity(title: 'Go walk', done: true),
    const TileActivity(
      title: 'Idz pobiegaj czy co tam chcesz nie wiem',
      done: false,
      subtitle: 'Whatever you want',
    ),
  ];

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
      body: ListView.builder(
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          final activity = _activities[index];
          return TileActivity(
            title: activity.title,
            done: activity.done,
            subtitle: activity.subtitle,
          );
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
      builder: (BuildContext context) {
        return const AddDialog();
      },
    );
  }
}
