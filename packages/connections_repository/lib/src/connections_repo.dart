import 'models/models.dart';

abstract class ConnectionsRepository {
  Future<void> sendConnectionRequest({
    required String senderId,
    required String receiverId,
    required String senderEmail,
  });
  Future<List<Connections>> loadIncomingRequests(String userId);
  Future<void> acceptConnectionRequest(String requestId);
  Future<void> declineConnectionRequest(String requestId);
  Future<void> unlinkConnection(String userId, String linkedPersonId);
  Future<Connections> getConnectionRequest(String requestId);
}
