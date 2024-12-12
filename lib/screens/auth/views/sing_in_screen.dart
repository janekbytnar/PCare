import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/my_text_button.dart';
import 'package:perfect_childcare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:perfect_childcare/components/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInFirebaseError = false;
  bool signInRequired = false;
  bool obscurePassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  String? _errorMsg;
  String? _errorMsgFirebase;

  Widget _emailField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        keyboardType: TextInputType.visiblePassword,
        prefixIcon: const Icon(CupertinoIcons.mail_solid),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
          } else if (!RegExp(r'^[\w=\.]+@([\w-]+.)+[\w-]{2,3}$')
              .hasMatch(val)) {
            return 'Invalid email format';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: passwordController,
        hintText: 'Password',
        obscureText: obscurePassword,
        keyboardType: TextInputType.visiblePassword,
        prefixIcon: const Icon(CupertinoIcons.lock_fill),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
          }
          // } else if (!passwordRexExp.hasMatch(val)) {
          //   return 'Please enter a valid password';
          // }
          return null;
        },
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
              if (obscurePassword) {
                iconPassword = CupertinoIcons.eye_fill;
              } else {
                iconPassword = CupertinoIcons.eye_slash_fill;
              }
            });
          },
          icon: Icon(iconPassword),
        ),
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: MyTextButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<SignInBloc>().add(SignInRequired(
                  emailController.text,
                  passwordController.text,
                ));
          }
        },
        text: 'Sign In',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          return;
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
            signInFirebaseError = false;
          });
        } else if (state is SignInFailure && state.message != null) {
          setState(() {
            signInFirebaseError = true;
            signInRequired = false;
            _errorMsgFirebase = state.message!
                .replaceFirst(
                    state.message![0], state.message![0].toUpperCase())
                .replaceAll('-', ' ');
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            signInFirebaseError = false;
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 10),
            _passwordField(),
            if (signInFirebaseError) const SizedBox(height: 10),
            if (signInFirebaseError)
              Text(
                // firebase error display
                _errorMsgFirebase ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            !signInRequired ? _button() : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
