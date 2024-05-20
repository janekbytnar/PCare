import 'package:flutter/material.dart';
import 'package:perfect_childcare/auth.dart';

class UpdateUserData extends StatefulWidget {
  const UpdateUserData({super.key});

  @override
  State<UpdateUserData> createState() => _UpdateUserDataState();
}

class _UpdateUserDataState extends State<UpdateUserData> {
  String? errorMessage = '';
  int _selectedOption = 0;

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Widget _title() {
    return const Text('Update Data');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$title can not be empty';
        } else if (title == "Username") {
          return 'username';
        }
        return null;
      },
    );
  }

  Widget _radio() {
    return Row(children: [
      Expanded(
        child: RadioListTile(
          title: const Text('Parent'),
          value: 0,
          groupValue: _selectedOption,
          onChanged: (int? value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
      ),
      Expanded(
        child: RadioListTile(
          title: const Text('Nanny'),
          value: 1,
          groupValue: _selectedOption,
          onChanged: (int? value) {
            setState(() {
              _selectedOption = value!;
            });
          },
        ),
      ),
    ]);
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: () {
        // Validate returns true if the form is valid, or false otherwise.
        if (_formKey.currentState!.validate()) {
          // If the form is valid, display a snackbar. In the real world,
          // you'd often call a server or save the information in a database.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('niby dziala xD')),
          );
        }
      },
      child: const Text('Update'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              _entryField('First Name', _controllerFirstName),
              _entryField("Surname", _controllerSurname),
              _entryField('Username', _controllerUsername),
              _radio(),
              _submitButton(),
              _signOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
