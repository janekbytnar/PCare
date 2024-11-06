part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequired extends RegisterEvent {
  final MyUser user;
  final String password;
  final bool isNanny;

  const RegisterRequired(this.user, this.password, this.isNanny);
}
