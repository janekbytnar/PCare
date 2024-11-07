import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
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

  const MyUser({
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

  static const empty = MyUser(
    userId: '',
    fcmToken: '',
    email: '',
    firstName: '',
    surname: '',
    imgUrl: '',
    isNanny: false,
    linkedPerson: '',
    children: [],
    sessions: [],
  );

  MyUser copyWith({
    String? userId,
    String? fcmToken,
    String? email,
    String? firstName,
    String? surname,
    String? imgUrl,
    bool? isNanny,
    String? linkedPerson,
    List<String>? children,
    List<String>? sessions,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      fcmToken: fcmToken ?? this.fcmToken,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      imgUrl: imgUrl ?? this.imgUrl,
      isNanny: isNanny ?? this.isNanny,
      linkedPerson: linkedPerson ?? this.linkedPerson,
      children: children ?? this.children,
      sessions: sessions ?? this.sessions,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      fcmToken: fcmToken,
      email: email,
      firstName: firstName,
      surname: surname,
      imgUrl: imgUrl,
      isNanny: isNanny,
      linkedPerson: linkedPerson,
      children: children,
      sessions: sessions,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      fcmToken: entity.fcmToken,
      email: entity.email,
      firstName: entity.firstName,
      surname: entity.surname,
      imgUrl: entity.imgUrl,
      isNanny: entity.isNanny,
      linkedPerson: entity.linkedPerson,
      children: entity.children,
      sessions: entity.sessions,
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
