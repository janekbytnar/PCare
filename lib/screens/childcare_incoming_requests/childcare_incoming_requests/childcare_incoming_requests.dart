import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:perfect_childcare/screens/session/blocs/nanny_management_bloc/nanny_connection_management_bloc.dart';
import 'package:user_repository/user_repository.dart';

class ChildcareIncomingRequestsScreen extends StatelessWidget {
  const ChildcareIncomingRequestsScreen({super.key});

  Widget _listView(BuildContext context, NannyConnectionsLoaded state) {
    return ListView.builder(
      itemCount: state.requests.length,
      itemBuilder: (context, index) {
        final request = state.requests[index];
        return _listTile(
          context,
          request.connectionId,
          request.senderEmail,
          request.startDate,
          request.endDate,
        );
      },
    );
  }

  Widget _listTile(
    BuildContext context,
    String connectionId,
    String senderEmail,
    DateTime startDate,
    DateTime endDate,
  ) {
    return ListTile(
      title: Text('Request from $senderEmail'), // Display sender's email
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.end, // align to right
        children: [
          Row(
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(startDate),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(width: 10),
              Text(
                  '${DateFormat('HH:mm').format(startDate)} - ${DateFormat('HH:mm').format(endDate)}'),
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _acceptButton(context, connectionId),
          _declineButton(context, connectionId),
        ],
      ),
    );
  }

  Widget _acceptButton(
    BuildContext context,
    String connectionId,
  ) {
    return IconButton(
      icon: const Icon(Icons.check, color: Colors.green),
      onPressed: () {
        context.read<NannyConnectionsManagementBloc>().add(
              AcceptNannyConnectionRequest(connectionId),
            );
      },
    );
  }

  Widget _declineButton(BuildContext context, String connectionId) {
    return IconButton(
      icon: const Icon(Icons.close, color: Colors.red),
      onPressed: () {
        context.read<NannyConnectionsManagementBloc>().add(
              DeclineNannyConnectionRequest(connectionId),
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

        final userId = snapshot.data!.userId;
        context
            .read<NannyConnectionsManagementBloc>()
            .add(LoadNannyConnectionRequests(userId));

        return Scaffold(
          appBar: AppBar(title: const Text('Connection Requests')),
          body: BlocBuilder<NannyConnectionsManagementBloc,
              NannyConnectionsManagementState>(
            builder: (context, state) {
              if (state is NannyConnectionsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NannyConnectionsLoaded) {
                if (state.requests.isEmpty) {
                  return const Center(child: Text('No incoming requests'));
                }
                return _listView(context, state);
              } else if (state is NannyConnectionsError) {
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
