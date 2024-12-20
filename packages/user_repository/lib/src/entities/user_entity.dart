import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final List<String> fcmTokens;
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
    required this.fcmTokens,
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
      'fcmTokens': fcmTokens,
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
      fcmTokens: List<String>.from(doc['fcmTokens'] ?? []),
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
        fcmTokens,
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
