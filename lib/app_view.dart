import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:perfect_childcare/screens/auth/error_screen/no_internet_screen.dart';
import 'package:perfect_childcare/screens/auth/views/welcome_screen.dart';
import 'package:perfect_childcare/screens/home/view/home.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profesional childcare',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Colors.grey.shade200,
          onBackground: Colors.black,
        ),
      ),
      home: BlocBuilder<InternetConnectionBloc, InternetConnectionState>(
        builder: (context, state) {
          if (state.status == InternetConnectionStatus.connected) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state.status == AuthenticationStatus.authenticated) {
                  return const HomeScreen();
                } else {
                  return const WelcomeScreen();
                }
              },
            );
          } else {
            return NoInternetScreen();
          }
        },
      ),
    );
  }
}
