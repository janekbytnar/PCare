import 'models/models.dart';

abstract class ChildRepository {
  Future<void> addChild(Child child); //Add child

  Future<void> removeChild(String childId); //Delete child

  Future<void> updateChild(Child child); //Update child

  Future<void> connectSessionToChild(
      String childId, String sessionId); //Connect session to child

  Stream<List<Child>> getChildrenForUserStream(
      String userId); // Dowload child for user
}
