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
  Future<void> updateSession(Session session);
//ADD NANNY TO SESSION
  Future<void> sendNannyConnectionRequest({
    required String sessionId,
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<List<NannyConnections>> loadIncomingNannyRequests(String userId);
  Future<void> acceptNannyConnectionRequest(String requestId);
  Future<void> declineNannyConnectionRequest(String requestId);
  Future<void> unlinkNannyConnection(String sessionId);
  Future<NannyConnections> getNannyConnectionRequest(String requestId);

//ACTIVITY
  Future<void> addActivity(String sessionId, Activity activity);
  Future<void> updateActivity(String sessionId, Activity activity);
  Future<void> deleteActivity(String sessionId, String activityId);
  Stream<List<Activity>> getActivities(String sessionId);
//MEAL
  Future<void> addMeal(String sessionId, Meal meal);
  Future<void> updateMeal(String sessionId, Meal meal);
  Future<void> deleteMeal(String sessionId, String mealId);
  Stream<List<Meal>> getMeals(String sessionId);
//Note
  Future<void> addNote(String sessionId, Note note);
  Future<void> updateNote(String sessionId, Note note);
  Future<void> deleteNote(String sessionId, String noteId);
  Stream<List<Note>> getNotes(String sessionId);
}
