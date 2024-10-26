import 'package:firebase_auth/firebase_auth.dart';
import 'models/models.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<MyUser> register(MyUser myUser, String password);

  Future<void> setUserData(MyUser myUser);

  Future<void> signIn(String email, String password);

  Future<void> signOut();

  Future<void> connectChildToUser(String userId, String childId);

  Future<void> connectSessionToUser(String userId, String sessionId);

  Future<MyUser?> getCurrentUserData();

  Stream<MyUser?> getCurrentUserDataStream();
}
