import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

part 'nanny_event.dart';
part 'nanny_state.dart';

class NannyBloc extends Bloc<NannyEvent, NannyState> {
  final UserRepository userRepository;
  NannyBloc({
    required this.userRepository,
  }) : super(const NannyState.unknown()) {
    on<CheckNannyStatus>(_onCheckNannyStatus);
  }

  void _onCheckNannyStatus(
      CheckNannyStatus event, Emitter<NannyState> emit) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const NannyState.isNotNanny()); // lub inny stan
        return;
      }
      final user = await userRepository.getUserById(event.userId);
      if (user != null && user.isNanny) {
        emit(const NannyState.isNanny());
      } else {
        emit(const NannyState.isNotNanny());
      }
    } catch (e) {
      emit(const NannyState.unknown());
    }
  }
}
