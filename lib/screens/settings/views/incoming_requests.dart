import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/blocs/children_bloc/children_bloc.dart';
import 'package:perfect_childcare/screens/settings/blocs/connections_management_bloc/connections_management_bloc.dart';
import 'package:user_repository/user_repository.dart';

class IncomingRequestsScreen extends StatelessWidget {
  const IncomingRequestsScreen({super.key});

  Widget _listView(
    BuildContext context,
    ConnectionsLoaded state,
    MyUser user,
  ) {
    return ListView.builder(
      itemCount: state.requests.length,
      itemBuilder: (context, index) {
        final request = state.requests[index];
        return _listTile(
            context, request.connectionId, request.senderEmail, user);
      },
    );
  }

  Widget _listTile(
    BuildContext context,
    String connectionId,
    String senderEmail,
    MyUser user,
  ) {
    return ListTile(
      title: Text('Request from $senderEmail'), // Display sender's email
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _acceptButton(context, connectionId, user),
          _declineButton(context, connectionId),
        ],
      ),
    );
  }

  Widget _acceptButton(
    BuildContext context,
    String connectionId,
    MyUser user,
  ) {
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.green),
      onPressed: () {
        context.read<ConnectionsManagementBloc>().add(
              AcceptConnectionRequest(connectionId),
            );
        Navigator.pop(context);
        context.read<ChildrenBloc>().add(ChildrenStatusChanged(user));
      },
    );
  }

  Widget _declineButton(BuildContext context, String connectionId) {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.red),
      onPressed: () {
        context.read<ConnectionsManagementBloc>().add(
              DeclineConnectionRequest(connectionId),
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyUser?>(
      future: context.read<UserRepository>().getCurrentUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Connection Requests')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Connection Requests')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Connection Requests')),
            body: const Center(child: Text('User not logged in')),
          );
        }
        final user = snapshot.data!;
        final userId = user.userId;
        context
            .read<ConnectionsManagementBloc>()
            .add(LoadConnectionRequests(userId));

        return Scaffold(
          appBar: AppBar(title: const Text('Connection Requests')),
          body: BlocBuilder<ConnectionsManagementBloc,
              ConnectionsManagementState>(
            builder: (context, state) {
              if (state is ConnectionsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ConnectionsLoaded) {
                if (state.requests.isEmpty) {
                  return const Center(child: Text('No incoming requests'));
                }
                return _listView(context, state, user);
              } else if (state is ConnectionsError) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
