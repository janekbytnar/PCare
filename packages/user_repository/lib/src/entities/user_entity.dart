import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String surname;
  final String imgUrl;
  final int updatedAt;
  final bool isNanny;
  final List<String> sessionID;

  const MyUserEntity({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.surname,
    required this.imgUrl,
    required this.updatedAt,
    required this.isNanny,
    required this.sessionID,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl, // Conversion date to String
      'updatedAt': updatedAt,
      'nanny': isNanny,
      'sessionID': sessionID,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        firstName: doc['firstName'],
        surname: doc['surname'],
        imgUrl: doc['imgUrl'],
        updatedAt: doc['updatedAt'],
        isNanny: doc['isNanny'],
        sessionID: doc['sessionID']);
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        surname,
        imgUrl,
        updatedAt,
        isNanny,
        sessionID,
      ];
}
