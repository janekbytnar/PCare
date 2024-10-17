import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool linked = false;

  Widget _logoutButton() {
    return IconButton(
      onPressed: () {
        context.read<SignInBloc>().add(
              const SignOutRequired(),
            );
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
    );
  }

  Widget _linkedInfo() {
    return linked
        ? Text(
            'Linked with: test@tescik.com',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 18,
            ),
          )
        : const Text(
            'No other parents linked',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          );
  }

  Widget _linkParentButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextButton(
        onPressed: () {
          // zmienic warunek i dodac co ma robic gdy jest linked
          if (!linked) {
            _showModalBottomSheet(context);
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: CupertinoColors.activeBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Text(linked ? 'Unlink' : 'Link with another parent',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  _emailField(),
                  const SizedBox(height: 12),
                  _linkButton(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emailField() {
    return MyTextField(
      obscureText: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(CupertinoIcons.mail_solid),
      hintText: 'Provide another person\'s email',
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please fill the field';
        } else if (!RegExp(r'^[\w=\.]+@([\w-]+.)+.[\w-]{2,3}$').hasMatch(val)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }

  Widget _linkButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final snackBar = SnackBar(
              content: Text('Linked with: ${emailController.text}'),
              showCloseIcon: true,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pop();
          }
        },
        style: TextButton.styleFrom(
          backgroundColor: CupertinoColors.activeBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Text('Link',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [_logoutButton()],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _linkedInfo(),
              _linkParentButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
