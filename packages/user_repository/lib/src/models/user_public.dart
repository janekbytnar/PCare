import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUserPublic extends Equatable {
  final String userId;
  final String email;
  final bool isNanny;

  const MyUserPublic({
    required this.userId,
    required this.email,
    required this.isNanny,
  });

  static const empty = MyUserPublic(
    userId: '',
    email: '',
    isNanny: false,
  );

  MyUserPublic copyWith({
    String? userId,
    String? email,
    bool? isNanny,
  }) {
    return MyUserPublic(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      isNanny: isNanny ?? this.isNanny,
    );
  }

  MyUserPublicEntity toEntity() {
    return MyUserPublicEntity(
      userId: userId,
      email: email,
      isNanny: isNanny,
    );
  }

  static MyUserPublic fromEntity(MyUserPublicEntity entity) {
    return MyUserPublic(
      userId: entity.userId,
      email: entity.email,
      isNanny: entity.isNanny,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        email,
        isNanny,
      ];
}
