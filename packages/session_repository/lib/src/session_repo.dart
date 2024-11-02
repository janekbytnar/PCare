import 'models/models.dart';

abstract class SessionRepository {
  //SESION
  Future<void> addSession(Session session);
  Future<void> removeSession(String sessionId);
  Future<List<Session>> checkSessionConflict(
    String parentId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<Session>> getSessions(List<String> sessionIds);

//ACTIVITY
  Future<void> addActivity(String sessionId, Activity activity);
  Future<void> updateActivity(String sessionId, Activity activity);
  Future<void> deleteActivity(String sessionId, String activityId);
  Stream<List<Activity>> getActivities(String sessionId);
}
