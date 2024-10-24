import 'models/models.dart';

abstract class SessionRepository {
  Future<void> addSession(
    Session session,
    List<String> parents,
    String childId,
    String nannyId,
  );

  Future<void> removeSession(String sessionId);
}
