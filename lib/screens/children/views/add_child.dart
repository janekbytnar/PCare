import 'package:child_repository/child_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_bloc_bloc.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_bloc_event.dart';
import 'package:provider/provider.dart';
import 'package:user_repository/user_repository.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? _errorMsg;

  void _addChild() {
    if (_formKey.currentState!.validate()) {
      final childName = nameController.text.trim();

      final currentUserId = context.read<AuthenticationBloc>().state.user!.uid;

      final newChild = Child(
        id: UniqueKey().toString(),
        name: childName,
        parentIds: [currentUserId],
      );

      context.read<ChildrenManagementBloc>().add(AddChildEvent(
            newChild,
            currentUserId,
          ));
      Navigator.pop(context);
    }
  }

  Widget _nameField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: nameController,
        hintText: 'Child\'s Name',
        obscureText: false,
        keyboardType: TextInputType.name,
        prefixIcon: const Icon(CupertinoIcons.person),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
          }
          return null;
        },
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: _addChild,
        child: const Text('Add Child'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Child'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _nameField(),
                const SizedBox(height: 20),
                _button(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
