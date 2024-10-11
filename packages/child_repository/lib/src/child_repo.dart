import 'models/models.dart';

abstract class ChildRepository {
  Future<void> addChild(Child child); //Add child

  Future<void> removeChild(String childId); //Delete child

  Future<List<Child>> getChildrenForUser(
      String userId); // Dowload child for user
}
