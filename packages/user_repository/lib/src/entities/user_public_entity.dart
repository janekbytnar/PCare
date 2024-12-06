import 'package:equatable/equatable.dart';

class MyUserPublicEntity extends Equatable {
  final String userId;
  final String email;
  final bool isNanny;

  const MyUserPublicEntity({
    required this.userId,
    required this.email,
    required this.isNanny,
  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'isNanny': isNanny,
    };
  }

  static MyUserPublicEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserPublicEntity(
      userId: doc['userId'] ?? '',
      email: doc['email'] ?? '',
      isNanny: doc['isNanny'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        isNanny,
      ];
}
