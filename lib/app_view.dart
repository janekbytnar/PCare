import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';

import 'package:perfect_childcare/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:perfect_childcare/blocs/session_bloc/session_bloc.dart';
import 'package:perfect_childcare/screens/error_screen/no_internet_screen.dart';
import 'package:perfect_childcare/screens/auth/views/welcome_screen.dart';
import 'package:perfect_childcare/screens/home/view/home.dart';
import 'package:perfect_childcare/screens/personal_information/views/personal_information_screen.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SessionBloc>(
            create: (context) => SessionBloc(
              userRepository: context.read<UserRepository>(),
              sessionRepository: context.read<SessionRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Professional Childcare',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              surface: Colors.grey.shade200,
              onSurface: Colors.black,
            ),
          ),
          home: BlocBuilder<InternetConnectionBloc, InternetConnectionState>(
            builder: (context, internetState) {
              if (internetState.status == InternetConnectionStatus.connected) {
                return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, authState) {
                    if (authState.status ==
                        AuthenticationStatus.authenticated) {
                      return const HomeScreen();
                    } else if (authState.status ==
                        AuthenticationStatus.authenticatedNoData) {
                      return const PersonalInformationScreen();
                    } else {
                      // User is not authenticated
                      return const WelcomeScreen();
                    }
                  },
                );
              } else {
                return const NoInternetScreen();
              }
            },
          ),
        ));
  }
}
