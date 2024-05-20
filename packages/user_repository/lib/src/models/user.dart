import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String surname;
  final String imgUrl;
  final int updatedAt;
  final bool isNanny;
  final List<String> sessionID;

  const MyUser({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.surname,
    required this.imgUrl,
    required this.updatedAt,
    required this.isNanny,
    required this.sessionID,
  });

  static const empty = MyUser(
    userId: '',
    email: '',
    firstName: '',
    surname: '',
    imgUrl: '',
    updatedAt: 0,
    isNanny: false,
    sessionID: [],
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? surname,
    String? imgUrl,
    int? updatedAt,
    bool? isNanny,
    List<String>? sessionID,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      imgUrl: imgUrl ?? this.imgUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      isNanny: isNanny ?? this.isNanny,
      sessionID: sessionID ?? this.sessionID,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      firstName: firstName,
      surname: surname,
      imgUrl: imgUrl,
      updatedAt: updatedAt,
      isNanny: isNanny,
      sessionID: sessionID,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      firstName: entity.firstName,
      surname: entity.surname,
      imgUrl: entity.imgUrl,
      updatedAt: entity.updatedAt,
      isNanny: entity.isNanny,
      sessionID: entity.sessionID,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        firstName,
        surname,
        imgUrl,
        updatedAt,
        isNanny,
        sessionID,
      ];
}
