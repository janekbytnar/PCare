// lib/screens/children/views/children_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/screens/children/views/add_child.dart';

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
      body: BlocBuilder<ChildrenBloc, ChildrenState>(
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
    );
    // _addButton(),
  }

  /* Widget _addButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddChildScreen()),
        ).then((_) {
          // Refresh the list after returning from AddChildScreen
          context.read<ChildrenBloc>().add(LoadChildrenEvent());
        });
      },
      child: const Text('Add Child'),
    );
  }*/
}
