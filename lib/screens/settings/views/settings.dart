// settings_screen.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/my_button.dart';
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
    // No need to call _loadUserLinkedStatus() since the stream listener handles it
  }

  Future<void> _loadUserLinkedStatus() async {
    try {
      final user = await context.read<UserRepository>().getCurrentUserData();
      if (!mounted) return;

      setState(() {
        linked = user?.linkedPerson.isNotEmpty ?? false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading linked status: ${e.toString()}')),
      );
    }
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

          return Text(
            isLinked
                ? 'Linked with: $linkedPersonId'
                : 'No other parents linked',
            style: TextStyle(
              color: isLinked ? Colors.grey[700] : Colors.red,
              fontSize: 18,
            ),
          );
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
                  child: IncomingRequestsScreen(),
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
          final email = emailController.text.trim();
          try {
            final user =
                await context.read<UserRepository>().getCurrentUserData();
            final userId = user?.userId;
            if (userId != null) {
              connectionsBloc.add(
                SendConnectionRequest(userId, email),
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
      text: 'Link',
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
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [_logoutButton()],
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
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
        ),
      ),
    );
  }
}
