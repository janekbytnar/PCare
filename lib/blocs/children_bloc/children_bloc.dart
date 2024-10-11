import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'children_event.dart';
part 'children_state.dart';

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  ChildrenBloc({required this.userRepository})
      : super(const ChildrenState.unknown()) {
    _userSubscription =
        userRepository.getCurrentUserDataStream().listen((myUser) {
      print('ChildrenBloc: Received user data update: $myUser');
      add(ChildrenStatusChanged(myUser));
    });
    on<ChildrenStatusChanged>(_onStatusChanged);
  }

  Future<void> _onStatusChanged(
      ChildrenStatusChanged event, Emitter<ChildrenState> emit) async {
    final user = event.user;
    print('ChildrenBloc: Processing user data: $user');
    if (user != null && user.children.isNotEmpty) {
      print('ChildrenBloc: Emitting hasChildren state');
      emit(const ChildrenState.hasChildren());
    } else {
      print('ChildrenBloc: Emitting childless state');
      emit(const ChildrenState.childless());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
