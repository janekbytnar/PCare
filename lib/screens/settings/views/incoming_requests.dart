import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/screens/settings/blocs/connections_management_bloc/connections_management_bloc.dart';
import 'package:user_repository/user_repository.dart';

class IncomingRequestsScreen extends StatelessWidget {
  const IncomingRequestsScreen({super.key});

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

        final userId = snapshot.data!.userId;
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
                return ListView.builder(
                  itemCount: state.requests.length,
                  itemBuilder: (context, index) {
                    final request = state.requests[index];
                    return ListTile(
                      title: Text(
                          'Request from ${request.connectionReceiverId}'), // Display sender's email
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              context.read<ConnectionsManagementBloc>().add(
                                    AcceptConnectionRequest(
                                        request.connectionId),
                                  );
                              Navigator.pop(context);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              context.read<ConnectionsManagementBloc>().add(
                                    DeclineConnectionRequest(
                                        request.connectionId),
                                  );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
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
