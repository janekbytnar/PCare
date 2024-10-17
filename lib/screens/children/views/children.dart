// lib/screens/children/views/children_screen.dart

import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_bloc_bloc.dart';
import 'package:perfect_childcare/screens/children/views/add_child.dart';
import 'package:user_repository/user_repository.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({Key? key}) : super(key: key);

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  int calculateAge(DateTime dateOfBirth) {
    DateTime today = DateTime.now();

    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  Widget _addButton() {
    return MyTextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => ChildrenManagementBloc(
                      childRepository: context.read<ChildRepository>(),
                      userRepository: context.read<UserRepository>(),
                    ),
                    child: const AddChildScreen(),
                  )),
        );
      },
      text: 'Add Child',
    );
  }

  Widget _listTiles(state) {
    return ListView.builder(
      itemCount: state.children.length,
      itemBuilder: (context, index) {
        final child = state.children[index];
        return _tile(child);
      },
    );
  }

  Widget _tile(child) {
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
                child.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )),
          const SizedBox(width: 10),
          Text('Age: ${calculateAge(child.dateOfBirth)}'),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChildrenBloc, ChildrenState>(
              builder: (context, state) {
                if (state.status == ChildrenStatus.hasChildren) {
                  return _listTiles(state);
                } else if (state.status == ChildrenStatus.childless) {
                  return const Center(
                      child: Text('User has no assigned children.'));
                } else if (state.status == ChildrenStatus.failure) {
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
