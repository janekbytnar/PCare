import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/active_session_bloc/session_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
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
  Widget _addButton() {
    return MyTextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => SessionManagementBloc(
                      sessionRepository: context.read<SessionRepository>(),
                      childRepository: context.read<ChildRepository>(),
                      userRepository: context.read<UserRepository>(),
                    ),
                    child: const AddSessionScreen(),
                  )),
        );
      },
      text: 'Add Session',
    );
  }

  Widget _listTiles(state) {
    return ListView.builder(
      itemCount: state.session.length,
      itemBuilder: (context, index) {
        final session = state.session[index];
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
      child: const ListTile(
          title: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(
                'imie dziecka',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
          const SizedBox(width: 10),
          Text('Wstawic Daty'),
        ],
      )),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SessionBloc, SessionState>(
              builder: (context, state) {
                if (state.status == SessionStatus.active) {
                  return _listTiles(state);
                } else if (state.status == SessionStatus.inactive) {
                  return const Center(child: Text('NO SESSION.'));
                } else if (state.status == SessionStatus.failure) {
                  return Center(
                      child: Text('Failed to load children: ${state.error}'));
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
