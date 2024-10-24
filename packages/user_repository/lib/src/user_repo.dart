import 'package:firebase_auth/firebase_auth.dart';
import 'package:session_repository/session_repository.dart';
import 'models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> register(MyUser myUser, String password);

  Future<void> setUserData(MyUser myUser);

  Future<void> signIn(String email, String password);

  Future<void> signOut();

  Future<void> connectChildToUser(String userId, String childId);

  Future<MyUser?> getCurrentUserData();

  Future<List<Session>> getSessions(List<String> sessionIds);

  Stream<MyUser?> getCurrentUserDataStream();

  getCurrentUserId() {}
}
