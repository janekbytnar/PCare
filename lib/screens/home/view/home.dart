import 'package:child_repository/child_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:perfect_childcare/blocs/session_bloc/session_bloc.dart';
import 'package:perfect_childcare/components/date_selector.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/screens/children/views/children.dart';
import 'package:perfect_childcare/screens/session/blocs/nanny_management_bloc/nanny_connection_management_bloc.dart';
import 'package:perfect_childcare/screens/session/views/persistent_nav.dart';
import 'package:perfect_childcare/components/side_bar.dart';
import 'package:perfect_childcare/screens/home/view/add_session.dart';
import 'package:perfect_childcare/screens/home/blocs/session_management_bloc/session_management_bloc.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    context
        .read<SessionBloc>()
        .add(LoadSessionsForDate(selectedDate)); //load session for initial date
    _loadUserData();
  }

//update children state
  void _loadUserData() async {
    final user = await context.read<UserRepository>().getCurrentUserData();
    if (user != null) {
      context.read<ChildrenBloc>().add(ChildrenStatusChanged(user));
    }
  }

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: MyTextButton(
        onPressed: isButtonEnabled
            ? () async {
                final sessionBloc = context.read<SessionBloc>();
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SessionManagementBloc(
                        sessionRepository: context.read<SessionRepository>(),
                        childRepository: context.read<ChildRepository>(),
                        userRepository: context.read<UserRepository>(),
                      ),
                      child: AddSessionScreen(selectedDate: selectedDate),
                    ),
                  ),
                );
                if (result == true) {
                  sessionBloc.add(LoadSessionsForDate(selectedDate));
                }
              }
            : null,
        text: 'Add Session',
      ),
    );
  }

  Widget _addChildButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: MyTextButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const ChildrenScreen(),
            ),
          );
        },
        text: 'Add your first child',
      ),
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
                  session.sessionName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                )),
            const SizedBox(width: 10),
            Text(
                '${DateFormat('HH:mm').format(session.startDate)} - ${DateFormat('HH:mm').format(session.endDate)}'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<SessionManagementBloc>(
                    create: (context) => SessionManagementBloc(
                      childRepository: context.read<ChildRepository>(),
                      userRepository: context.read<UserRepository>(),
                      sessionRepository: context.read<SessionRepository>(),
                    ),
                  ),
                  BlocProvider<NannyConnectionsManagementBloc>(
                    create: (context) => NannyConnectionsManagementBloc(
                      userRepository: context.read<UserRepository>(),
                      sessionRepository: context.read<SessionRepository>(),
                    ),
                  ),
                ],
                child: PersistentTabScreen(session: session),
              ),
            ),
          );
        },
      ),
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
            onDateChanged: _onDateSelected,
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
          BlocBuilder<NannyBloc, NannyState>(
            builder: (context, nannyState) {
              switch (nannyState.status) {
                case NannyStatus.isNanny:
                  return const SizedBox.shrink();
                case NannyStatus.isNotNanny:
                  {
                    return BlocBuilder<ChildrenBloc, ChildrenState>(
                      builder: (context, state) {
                        if (state.status == ChildrenStatus.hasChildren) {
                          return _addButton();
                        } else if (state.status == ChildrenStatus.childless) {
                          return _addChildButton();
                        } else if (state.status == ChildrenStatus.failure) {
                          return Center(
                              child: Text(
                                  'Failed to load children: ${state.error}'));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    );
                  }
                case NannyStatus.unknown:
                default:
                  return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
