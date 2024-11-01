import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:perfect_childcare/blocs/session_bloc/session_bloc.dart';
import 'package:perfect_childcare/components/date_selector.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/components/side_bar.dart';
import 'package:perfect_childcare/screens/home/view/add_session.dart';
import 'package:perfect_childcare/screens/session/blocs/session_management_bloc/session_management_bloc.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  bool get isButtonEnabled {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    return selectedDay.isAfter(today) || selectedDay.isAtSameMomentAs(today);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    context.read<SessionBloc>().add(LoadSessionsForDate(selectedDate));
  }

  Widget _addButton() {
    return MyTextButton(
      onPressed: isButtonEnabled
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (context) => SessionManagementBloc(
                            sessionRepository:
                                context.read<SessionRepository>(),
                            childRepository: context.read<ChildRepository>(),
                            userRepository: context.read<UserRepository>(),
                          ),
                          child: AddSessionScreen(selectedDate: selectedDate),
                        )),
              );
            }
          : null,
      text: 'Add Session',
    );
  }

  Widget _listTiles(state) {
    return ListView.builder(
      itemCount: state.sessions.length,
      itemBuilder: (context, index) {
        final session = state.sessions[index];
        return _tile(session);
      },
    );
  }

  Widget _tile(session) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      color: Colors.blue,
      margin: const EdgeInsets.fromLTRB(20.0, 13.0, 20.0, 0),
      child: ListTile(
          title: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                session.sessionId,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
          const SizedBox(width: 10),
          Text(
              '${DateFormat('HH:mm').format(session.startDate)} - ${DateFormat('HH:mm').format(session.endDate)}'),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const SideBar(),
      body: Column(
        children: [
          DateSelector(
            selectedDate: selectedDate,
            onDateChanged: (newDate) {
              _onDateSelected(newDate);
              setState(() {
                selectedDate = newDate;
              });
            },
          ),
          Expanded(
            child: BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                if (state.status == SessionStatus.active) {
                  return _listTiles(state);
                } else if (state.status == SessionStatus.inactive) {
                  return Center(
                      child: Text(
                          'No sessions on ${DateFormat.yMMMd().format(state.selectedDate!)}'));
                } else if (state.status == SessionStatus.failure) {
                  return Center(
                      child: Text('Failed to load sessions: ${state.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          _addButton(),
        ],
      ),
    );
  }
}
