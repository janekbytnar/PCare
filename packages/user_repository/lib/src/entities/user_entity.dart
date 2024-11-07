import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String fcmToken;
  final String email;
  final String firstName;
  final String surname;
  final String imgUrl;
  final bool isNanny;
  final String linkedPerson;
  final List<String> children;
  final List<String> sessions;

  const MyUserEntity({
    required this.userId,
    required this.fcmToken,
    required this.email,
    required this.firstName,
    required this.surname,
    required this.imgUrl,
    required this.isNanny,
    required this.linkedPerson,
    required this.children,
    required this.sessions,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'fcmToken': fcmToken,
      'email': email,
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'isNanny': isNanny,
      'linkedPerson': linkedPerson,
      'children': children,
      'sessions': sessions,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'] ?? '',
      fcmToken: doc['fcmToken'] ?? '',
      email: doc['email'] ?? '',
      firstName: doc['firstName'] ?? '',
      surname: doc['surname'] ?? '',
      imgUrl: doc['imgUrl'] ?? '',
      isNanny: doc['isNanny'] ?? false,
      linkedPerson: doc['linkedPerson'] ?? '',
      children: (doc['children'] as List<dynamic>?)
              ?.map((childId) => childId as String)
              .toList() ??
          [],
      sessions: (doc['sessions'] as List<dynamic>?)
              ?.map((sessionId) => sessionId as String)
              .toList() ??
          [],
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fcmToken,
        email,
        firstName,
        surname,
        imgUrl,
        isNanny,
        linkedPerson,
        children,
        sessions,
      ];
}
