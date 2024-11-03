import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('user');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> register(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      myUser = myUser.copyWith(
        userId: user.user!.uid,
      );

      return myUser;
    } catch (e) {
      log('Error create user: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log('Error setUserData: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log('Error signOut: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> connectChildToUser(String userId, String childId) async {
    try {
      await usersCollection.doc(userId).update({
        'children': FieldValue.arrayUnion([childId]),
      });
    } catch (e) {
      log('Error addChildToUser: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> connectSessionToUser(String userId, String sessionId) async {
    try {
      await usersCollection.doc(userId).update({
        'sessions': FieldValue.arrayUnion([sessionId]),
      });
    } catch (e) {
      log('Error addChildToUser: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<MyUser?> getCurrentUserData() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId != null) {
      final doc = await usersCollection.doc(userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return MyUser.fromEntity(MyUserEntity.fromDocument(data));
      } else {
        // user document doesn't exist
        return null;
      }
    } else {
      // User is not logged in
      return null;
    }
  }

  @override
  Stream<MyUser?> getCurrentUserDataStream() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId != null) {
      return usersCollection.doc(userId).snapshots().map((snapshot) {
        final data = snapshot.data();
        if (data != null) {
          return MyUser.fromEntity(MyUserEntity.fromDocument(data));
        } else {
          return null;
        }
      });
    } else {
      return Stream.value(null);
    }
  }

  @override
  Future<void> disconnectChildFromUser(String childId) async {
    final userId = _firebaseAuth.currentUser?.uid;
    print('disconnectChildFromUser: userId = $userId, childId = $childId');
    if (userId != null) {
      try {
        await usersCollection.doc(userId).update({
          'children': FieldValue.arrayRemove([childId]),
        });
      } catch (e) {
        log('Error disconnectChildFromUser: ${e.toString()}');
        rethrow;
      }
    }
  }

  @override
  Future<String?> getUserIdByEmail(String email) async {
    final querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Return the user ID
    } else {
      return null; // Email not found
    }
  }

  @override
  Future<void> addLinkedPerson(String userId, String linkedPersonId) async {
    try {
      await usersCollection.doc(userId).update({
        'linkedPerson': linkedPersonId,
      });
      await usersCollection.doc(linkedPersonId).update({
        'linkedPerson': userId,
      });
    } catch (e) {
      log('Error adding linkedPerson: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> unlinkPerson(String userId, String linkedPersonId) async {
    try {
      await usersCollection.doc(userId).update({
        'linkedPerson': '',
      });
      await usersCollection.doc(linkedPersonId).update({
        'linkedPerson': '',
      });
    } catch (e) {
      log('Error unlinkConnection: ${e.toString()}');
      rethrow;
    }
  }
}
