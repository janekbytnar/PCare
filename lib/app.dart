import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/app_view.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<UserRepository>(
      create: (context) => userRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<ChildrenBloc>(
            create: (context) => ChildrenBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<InternetConnectionBloc>(
            create: (context) => InternetConnectionBloc(),
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}
