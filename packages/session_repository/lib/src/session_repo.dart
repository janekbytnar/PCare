import 'models/models.dart';

abstract class SessionRepository {
  Future<void> addSession(Session session);

  Future<void> removeSession(String sessionId);

  Future<List<Session>> checkSessionConflict(
    String parentId,
    DateTime startDate,
    DateTime endDate,
  );

  Future<List<Session>> getSessions(List<String> sessionIds);
}
