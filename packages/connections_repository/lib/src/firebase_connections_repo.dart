import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connections_repository/connections_repository.dart';

class FirebaseConnectionsRepo implements ConnectionsRepository {
  final connectionsCollection =
      FirebaseFirestore.instance.collection('connections');

  FirebaseConnectionsRepo();

  @override
  Future<void> sendConnectionRequest({
    required String senderId,
    required String receiverId,
    required String senderEmail,
  }) async {
    // Check for existing request
    final existingRequest = await connectionsCollection
        .where('connectionSenderId', isEqualTo: senderId)
        .where('connectionReceiverId', isEqualTo: receiverId)
        .where('status', isEqualTo: 'pending')
        .where('senderEmail', isEqualTo: senderEmail)
        .get();

    if (existingRequest.docs.isNotEmpty) {
      throw Exception('Connection request already sent');
    }
    final docRef = connectionsCollection.doc();
    // Create new connection request
    await connectionsCollection.add({
      'connectionId': docRef.id,
      'connectionSenderId': senderId,
      'senderEmail': senderEmail,
      'connectionReceiverId': receiverId,
      'status': 'pending',
      'requestTime': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<List<Connections>> loadIncomingRequests(String userId) async {
    final querySnapshot = await connectionsCollection
        .where('connectionReceiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Connections(
        connectionId: doc.id,
        connectionSenderId: data['connectionSenderId'],
        senderEmail: data['senderEmail'],
        connectionReceiverId: data['connectionReceiverId'],
        status: data['status'],
        requestTime: (data['requestTime'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> acceptConnectionRequest(String requestId) async {
    final requestRef = connectionsCollection.doc(requestId);
    final requestDoc = await requestRef.get();

    if (requestDoc.exists && requestDoc['status'] == 'pending') {
      await requestRef.update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      throw Exception('Invalid or already processed request.');
    }
  }

  @override
  Future<void> declineConnectionRequest(String requestId) async {
    final requestRef = connectionsCollection.doc(requestId);
    await requestRef.update({
      'status': 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> unlinkConnection(String userId, String connectedUserId) async {
    // Query 1: Where `connectionSenderId` is `userId` and `status` is `accepted`
    final senderQuery = await connectionsCollection
        .where('connectionSenderId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    // Query 2: Where `connectionReceiverId` is `userId` and `status` is `accepted`
    final receiverQuery = await connectionsCollection
        .where('connectionReceiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    // Ensure only one document exists in senderQuery
    if (senderQuery.docs.length == 1) {
      final doc = senderQuery.docs.first;
      final oldData = doc.data(); // Data from the existing document
      await doc.reference.update({
        'connectionId': oldData['connectionId'],
        'connectionSenderId': oldData['connectionSenderId'],
        'senderEmail': oldData['senderEmail'],
        'connectionReceiverId': oldData['connectionReceiverId'],
        'requestTime': oldData['requestTime'],
        'status': 'unlinked',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // Ensure only one document exists in receiverQuery
    if (receiverQuery.docs.length == 1) {
      final doc = receiverQuery.docs.first;
      final oldData = doc.data(); // Data from the existing document
      await doc.reference.update({
        'connectionId': oldData['connectionId'],
        'connectionSenderId': oldData['connectionSenderId'],
        'senderEmail': oldData['senderEmail'],
        'connectionReceiverId': oldData['connectionReceiverId'],
        'requestTime': oldData['requestTime'],
        'status': 'unlinked',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<Connections> getConnectionRequest(String requestId) async {
    final requestRef = connectionsCollection.doc(requestId);
    final requestDoc = await requestRef.get();

    if (!requestDoc.exists) {
      throw Exception('Connection request not found.');
    }

    final data = requestDoc.data()!;
    return Connections(
      connectionId: requestDoc.id,
      connectionSenderId: data['connectionSenderId'],
      senderEmail: data['senderEmail'],
      connectionReceiverId: data['connectionReceiverId'],
      status: data['status'],
      requestTime: (data['requestTime'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}
