import 'package:child_repository/child_repository.dart';
import 'package:connections_repository/connections_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/app_view.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/internet_connection_bloc/internet_connection_bloc.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:session_repository/session_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final ChildRepository childRepository;
  final SessionRepository sessionRepository;
  final ConnectionsRepository connectionsRepository;
  const MyApp(this.userRepository, this.childRepository, this.sessionRepository,
      this.connectionsRepository,
      {super.key});

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
        RepositoryProvider<SessionRepository>(
          create: (_) => sessionRepository,
        ),
        RepositoryProvider<ConnectionsRepository>(
          create: (_) => connectionsRepository,
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<InternetConnectionBloc>(
            create: (context) => InternetConnectionBloc(),
          ),
          BlocProvider<NannyBloc>(
            create: (context) => NannyBloc(
              userRepository: context.read<UserRepository>(),
            ),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              userRepository: context.read<UserRepository>(),
              nannyBloc: context.read<NannyBloc>(),
            ),
          ),
          BlocProvider<ChildrenBloc>(
            create: (context) => ChildrenBloc(
              childRepository: context.read<ChildRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
        ],
        child: const MyAppView(),
      ),
    );
  }
}
