import 'package:child_repository/child_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/app_view.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final ChildRepository childRepository;
  const MyApp(this.userRepository, this.childRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (_) => userRepository,
        ),
        RepositoryProvider<ChildRepository>(
          create: (_) => childRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<ChildrenBloc>(
            create: (context) => ChildrenBloc(
              childRepository: context.read<ChildRepository>(),
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
