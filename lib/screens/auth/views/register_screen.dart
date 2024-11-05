import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
import 'package:perfect_childcare/screens/auth/blocs/register_bloc/register_bloc.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:user_repository/user_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool registerFirebaseError = false;
  bool registerRequired = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  IconData iconPassword = CupertinoIcons.eye_fill;
  IconData iconConfirmPassword = CupertinoIcons.eye_fill;
  String? _errorMsg;
  String? _errorMsgFirebase;

  Widget _emailField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: emailController,
        hintText: 'Email',
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: const Icon(CupertinoIcons.mail_solid),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
          } else if (!RegExp(r'^[\w=\.]+@([\w-]+.)+.[\w-]{2,3}$')
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

  Widget _confirmPasswordField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: MyTextField(
        controller: confirmPasswordController,
        hintText: 'Confirm password',
        obscureText: obscureConfirmPassword,
        keyboardType: TextInputType.visiblePassword,
        prefixIcon: const Icon(CupertinoIcons.lock_fill),
        errorMsg: _errorMsg,
        validator: (val) {
          if (val!.isEmpty) {
            return 'Please fill the field';
            // } else if (!passwordRexExp.hasMatch(val)) {
            //   return 'Please enter a valid password';
            // }
          } else if (passwordController.text != val) {
            return 'Passwords do not match';
          }
          return null;
        },
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscureConfirmPassword = !obscureConfirmPassword;
              if (obscureConfirmPassword) {
                iconConfirmPassword = CupertinoIcons.eye_fill;
              } else {
                iconConfirmPassword = CupertinoIcons.eye_slash_fill;
              }
            });
          },
          icon: Icon(iconConfirmPassword),
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
            MyUser myUser = MyUser.empty;
            myUser = myUser.copyWith(
              email: emailController.text.toLowerCase(),
            );
            setState(() {
              context.read<RegisterBloc>().add(RegisterRequired(
                    myUser,
                    passwordController.text,
                  ));
            });
          }
        },
        text: 'Register',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          setState(() {
            registerRequired = false;
          });
        } else if (state is RegisterProcess) {
          setState(() {
            registerRequired = true;
          });
        } else if (state is RegisterFailure && state.message != null) {
          setState(() {
            registerFirebaseError = true;
            registerRequired = false;
            _errorMsgFirebase = state.message!
                .replaceFirst(
                    state.message![0], state.message![0].toUpperCase())
                .replaceAll('-', ' ');
          });
        } else if (state is RegisterFailure) {
          setState(() {
            registerRequired = false;
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
            const SizedBox(height: 10),
            _confirmPasswordField(),
            if (registerFirebaseError) const SizedBox(height: 10),
            if (registerFirebaseError)
              Text(
                // firebase error display
                _errorMsgFirebase ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            !registerRequired ? _button() : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
