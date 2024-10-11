/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:child_repository/child_repository.dart';
import 'package:perfect_childcare/components/my_text_field.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({Key? key}) : super(key: key);

  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String? _errorMsg;

  bool _isLoading = false;

  Future<void> _addChild() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final userRepository =
            context.read<AuthenticationBloc>().userRepository;
        final currentUser = await userRepository.getCurrentUserData();

        // Create new Child
        final newChild = Child(
          id: _firestore.collection('children').doc().id,
          name: nameController.text.trim(),
          parentIds: [currentUser!.userId],
        );

        // Save the child to the database
        final childRepository = FirebaseChildRepo();
        await childRepository.addChild(newChild);

        // Update the user's children list
        final updatedChildren = List<Child>.from(currentUser.children)
          ..add(newChild);
        final updatedUser = currentUser.copyWith(children: updatedChildren);

        // Save the updated user to the database
        await userRepository.setUserData(updatedUser);

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Child ${newChild.name} added successfully!')),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding child: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a Child'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Child\'s Name',
                        prefixIcon: Icon(Icons.child_care),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the child\'s name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addChild,
                      child: const Text('Add Child'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

*/