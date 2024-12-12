// settings_screen.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/blocs/nanny_bloc/nanny_bloc.dart';
import 'package:perfect_childcare/blocs/session_bloc/session_bloc.dart';
import 'package:perfect_childcare/components/my_text_button.dart';
import 'package:perfect_childcare/components/my_text_field.dart';
import 'package:perfect_childcare/screens/auth/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:perfect_childcare/screens/settings/blocs/connections_management_bloc/connections_management_bloc.dart';
import 'package:perfect_childcare/screens/settings/views/incoming_requests.dart';
import 'package:user_repository/user_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool linked = false;
  MyUser? currentUser;
  late StreamSubscription<MyUser?> _userSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize the stream subscription
    _userSubscription = context
        .read<UserRepository>()
        .getCurrentUserDataStream()
        .listen((user) {
      if (!mounted) return;
      setState(() {
        currentUser = user;
        linked = user?.linkedPerson.isNotEmpty ?? false;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    _userSubscription.cancel();
    super.dispose();
  }

  Widget _logoutButton() {
    return IconButton(
      onPressed: () {
        _userSubscription.cancel();
        BlocProvider.of<ChildrenBloc>(context)
            .add(const StopListeningChildren());
        BlocProvider.of<SessionBloc>(context).add(const StopListeningSession());
        context.read<SignInBloc>().add(
              const SignOutRequired(),
            );
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
      ),
    );
  }

  Widget _linkedInfo() {
    return StreamBuilder<MyUser?>(
      stream: context.read<UserRepository>().getCurrentUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final myUser = snapshot.data!;
          final linkedPersonId = myUser.linkedPerson;
          final isLinked = linkedPersonId.isNotEmpty;

          if (isLinked) {
            // Fetch the linked person's email
            return FutureBuilder<MyUserPublic?>(
              future: context
                  .read<UserRepository>()
                  .getUserPublicById(linkedPersonId),
              builder: (context, linkedUserSnapshot) {
                if (linkedUserSnapshot.hasData &&
                    linkedUserSnapshot.data != null) {
                  final linkedUser = linkedUserSnapshot.data!;
                  final userEmail = linkedUser.email;
                  return Text(
                    'Linked with $userEmail',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 18,
                    ),
                  );
                } else if (linkedUserSnapshot.hasError) {
                  return Text(
                    'Error: ${linkedUserSnapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            return const Text(
              'No other parents linked',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _linkParentButton() {
    return MyTextButton(
      onPressed: () {
        if (!linked) {
          _showModalBottomSheet(context);
        } else {
          _unlinkUsers();
        }
      },
      text: linked ? 'Unlink' : 'Link with another parent',
    );
  }

  Widget _incomingRequestButton() {
    return Builder(
      builder: (context) {
        return MyTextButton(
          onPressed: () {
            // Access the ConnectionsManagementBloc from the correct context
            final connectionsBloc = context.read<ConnectionsManagementBloc>();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: connectionsBloc,
                  child: const IncomingRequestsScreen(),
                ),
              ),
            );
          },
          text: 'Incoming Requests',
        );
      },
    );
  }

  void _unlinkUsers() async {
    if (!mounted) return;
    try {
      if (currentUser != null && currentUser!.linkedPerson.isNotEmpty) {
        final userId = currentUser!.userId;
        final linkedPersonId = currentUser!.linkedPerson;

        context.read<ConnectionsManagementBloc>().add(
              UnlinkConnection(userId, linkedPersonId),
            );
        context.read<ChildrenBloc>().add(ChildrenStatusChanged(currentUser!));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unlinked successfully.')),
        );

        setState(() {
          linked = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No linked person to unlink.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  _emailField(),
                  const SizedBox(height: 12),
                  _linkButton(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emailField() {
    return MyTextField(
      obscureText: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(CupertinoIcons.mail_solid),
      hintText: 'Provide another person\'s email',
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please fill the field';
        } else if (!RegExp(r'^[\w=\.]+@([\w-]+\.)+[\w-]{2,3}$').hasMatch(val)) {
          return 'Invalid email format';
        }
        return null;
      },
    );
  }

  Widget _linkButton() {
    return MyTextButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final connectionsBloc = context.read<ConnectionsManagementBloc>();
          final receiverEmail = emailController.text.trim();
          try {
            final user =
                await context.read<UserRepository>().getCurrentUserData();
            final userId = user?.userId;
            final senderEmail = user?.email;
            if (userId != null && senderEmail != null) {
              connectionsBloc.add(
                SendConnectionRequest(userId, senderEmail, receiverEmail),
              );
              Navigator.of(context).pop();
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('User not logged in or data not available')),
                );
              }
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          }
        }
      },
      text: 'Send request for link',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectionsManagementBloc, ConnectionsManagementState>(
      listener: (context, state) {
        if (state is ConnectionRequestSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connection request sent!')),
          );
        } else if (state is ConnectionRequestAccepted) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Connection accepted!')),
          );
          setState(() {
            linked = true;
          });
        } else if (state is ConnectionUnlinked) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unlinked successfully.')),
          );
          setState(() {
            linked = false;
          });
        } else if (state is ConnectionsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [_logoutButton()],
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body:
            BlocBuilder<NannyBloc, NannyState>(builder: (context, nannyState) {
          switch (nannyState.status) {
            case NannyStatus.isNotNanny:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _linkedInfo(),
                      linked ? Container() : _incomingRequestButton(),
                      _linkParentButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            case NannyStatus.isNanny:
              return const Center(
                child: Text(
                  'You are nanny',
                  style: TextStyle(fontSize: 20),
                ),
              );
            case NannyStatus.unknown:
              return const Center(
                child: Text(
                  'Unknown nanny status',
                  style: TextStyle(fontSize: 20),
                ),
              );
          }
        }),
      ),
    );
  }
}
