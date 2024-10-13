// lib/screens/children/views/children_screen.dart

import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_bloc_bloc.dart';
import 'package:perfect_childcare/screens/children/views/add_child.dart';
import 'package:user_repository/user_repository.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({Key? key}) : super(key: key);

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ChildrenBloc, ChildrenState>(
              builder: (context, state) {
                final state = context.watch<ChildrenBloc>().state;
                if (state.status == ChildrenStatus.hasChildren) {
                  return Center(child: Text('User has assigned children.'));
                } else if (state.status == ChildrenStatus.childless) {
                  return Center(child: Text('User has no assigned children.'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
            _addButton(),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return ElevatedButton(
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
      child: const Text('Add Child'),
    );
  }
}
