import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
