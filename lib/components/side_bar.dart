import 'package:connections_repository/connections_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:perfect_childcare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:perfect_childcare/screens/children/views/children.dart';
import 'package:perfect_childcare/screens/childcare_incoming_requests/childcare_incoming_requests/childcare_incoming_requests.dart';
import 'package:perfect_childcare/screens/personal_information/views/personal_information_screen.dart';
import 'package:perfect_childcare/screens/session/blocs/nanny_management_bloc/nanny_connection_management_bloc.dart';
import 'package:perfect_childcare/screens/settings/blocs/connections_management_bloc/connections_management_bloc.dart';
import 'package:perfect_childcare/screens/settings/views/settings.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';

class SideBar extends StatefulWidget {
  const SideBar({
    super.key,
  });

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Widget buildHeader(BuildContext context) {
    final userRepository = context.watch<UserRepository>();
    return Material(
      color: Colors.grey.shade800,
      child: FutureBuilder<MyUser?>(
        future: userRepository.getCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PersonalInformationScreen(),
                  ),
                );
                // after back from personal screen refresh
                setState(() {});
              },
              child: Container(
                padding: EdgeInsets.only(
                  top: 24 + MediaQuery.of(context).padding.top,
                  bottom: 24,
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 52,
                      backgroundImage: AssetImage("assets/face.png"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      '${user.firstName} ${user.surname}',
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

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
                      return ListTile(
                        leading: const Icon(Icons.child_care),
                        title: const Text("Children"),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ChildrenScreen(),
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
          BlocBuilder<NannyBloc, NannyState>(
            builder: (context, nannyState) {
              switch (nannyState.status) {
                case NannyStatus.isNotNanny:
                  return const SizedBox.shrink();
                case NannyStatus.isNanny:
                  return Builder(
                    builder: (context) {
                      return ListTile(
                        leading: const Icon(Icons.child_care),
                        title: const Text("Childcare Requests"),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  BlocProvider<NannyConnectionsManagementBloc>(
                                create: (context) =>
                                    NannyConnectionsManagementBloc(
                                  userRepository:
                                      context.read<UserRepository>(),
                                  sessionRepository:
                                      context.read<SessionRepository>(),
                                ),
                                child: const ChildcareIncomingRequestsScreen(),
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
                      child: const SettingsScreen(),
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
