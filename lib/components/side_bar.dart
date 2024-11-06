import 'package:connections_repository/connections_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:perfect_childcare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
//import 'package:perfect_childcare/screens/nannies/nannies/nannies.dart';
import 'package:perfect_childcare/screens/children/views/children.dart';
import 'package:perfect_childcare/screens/personal_information/views/personal_information_screen.dart';
import 'package:perfect_childcare/screens/settings/blocs/connections_management_bloc/connections_management_bloc.dart';
import 'package:perfect_childcare/screens/settings/views/settings.dart';
import 'package:user_repository/user_repository.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
  });
  Widget buildHeader(BuildContext context) => Material(
        color: Colors.grey.shade800,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository,
                  ),
                  child: const PersonalInformationScreen(),
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundImage: AssetImage("assets/face.png"),
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'John Smith',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  'test@testemail.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildMenuItems(BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(CupertinoIcons.house_fill),
            title: const Text("Home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          BlocBuilder<NannyBloc, NannyState>(
            builder: (context, nannyState) {
              switch (nannyState.status) {
                case NannyStatus.isNanny:
                  return const SizedBox.shrink();
                case NannyStatus.isNotNanny:
                  return Builder(
                    builder: (context) {
                      final childrenBloc = context.read<ChildrenBloc>();
                      return ListTile(
                        leading: const Icon(Icons.child_care),
                        title: const Text("Children"),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: childrenBloc,
                                child: const ChildrenScreen(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                case NannyStatus.unknown:
                default:
                  return const SizedBox.shrink();
              }
            },
          ),

          /*ListTile(
            leading: const Icon(Icons.child_friendly),
            title: const Text("Nannies"),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const NanniesScreen(),
                ),
              );
            },
          ),*/
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    final userRepository = context.read<UserRepository>();
                    final connectionsRepository =
                        context.read<ConnectionsRepository>();

                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => SignInBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => ConnectionsManagementBloc(
                            userRepository: userRepository,
                            connectionsRepository: connectionsRepository,
                          ),
                        ),
                      ],
                      child: SettingsScreen(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: Colors.grey.withOpacity(0.86),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
}
