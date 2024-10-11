import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String surname;
  final String imgUrl;
  final bool isNanny;
  final String linkedPerson;
  final List<String> children;

  const MyUserEntity({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.surname,
    required this.imgUrl,
    required this.isNanny,
    required this.linkedPerson,
    required this.children,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'surname': surname,
      'imgUrl': imgUrl,
      'nanny': isNanny,
      'linkedPerson': linkedPerson,
      'children': children,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'] ?? '',
      email: doc['email'] ?? '',
      firstName: doc['firstName'] ?? '',
      surname: doc['surname'] ?? '',
      imgUrl: doc['imgUrl'] ?? '',
      isNanny: doc['isNanny'] ?? false,
      linkedPerson: doc['linkedPerson'] ?? '',
      children: List<String>.from(doc['children']),
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        firstName,
        surname,
        imgUrl,
        isNanny,
        linkedPerson,
        children,
      ];
}
