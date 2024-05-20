import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:perfect_childcare/screens/auth/welcome_screen.dart';
import 'package:perfect_childcare/screens/home/home.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Profesional childcare',
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return BlocProvider(
                create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
                child: const HomeScreen(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ));
  }
}
