import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String firstName;
  final String surname;
  final String imgUrl;
  final bool isNanny;
  final String linkedPerson;
  final List<String> children;

  const MyUser({
    required this.userId,
    required this.email,
    required this.firstName,
    required this.surname,
    required this.imgUrl,
    required this.isNanny,
    required this.linkedPerson,
    required this.children,
  });

  static const empty = MyUser(
    userId: '',
    email: '',
    firstName: '',
    surname: '',
    imgUrl: '',
    isNanny: false,
    linkedPerson: '',
    children: [],
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? surname,
    String? imgUrl,
    bool? isNanny,
    String? linkedPerson,
    List<String>? children,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      imgUrl: imgUrl ?? this.imgUrl,
      isNanny: isNanny ?? this.isNanny,
      linkedPerson: linkedPerson ?? this.linkedPerson,
      children: children ?? this.children,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      firstName: firstName,
      surname: surname,
      imgUrl: imgUrl,
      isNanny: isNanny,
      linkedPerson: linkedPerson,
      children: children,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      firstName: entity.firstName,
      surname: entity.surname,
      imgUrl: entity.imgUrl,
      isNanny: entity.isNanny,
      linkedPerson: entity.linkedPerson,
      children: entity.children,
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
