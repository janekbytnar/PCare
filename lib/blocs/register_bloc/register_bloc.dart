import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterInitial()) {
    on<RegisterRequired>((event, emit) async {
      emit(RegisterProcess());
      try {
        MyUser user =
            await _userRepository.register(event.user, event.password);
        await _userRepository.setUserData(user);
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        emit(RegisterFailure(message: e.code));
      } catch (e) {
        emit(const RegisterFailure());
      }
    });
  }
}
