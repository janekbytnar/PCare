import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:child_repository/child_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'children_event.dart';
part 'children_state.dart';

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  final UserRepository userRepository;
  final ChildRepository childRepository;
  late final StreamSubscription<MyUser?> _userSubscription;

  ChildrenBloc({
    required this.userRepository,
    required this.childRepository,
  }) : super(const ChildrenState.unknown()) {
    _userSubscription =
        userRepository.getCurrentUserDataStream().listen((myUser) {
      add(ChildrenStatusChanged(myUser));
    });
    on<ChildrenStatusChanged>(_onStatusChanged);
  }

  Future<void> _onStatusChanged(
      ChildrenStatusChanged event, Emitter<ChildrenState> emit) async {
    final user = event.user;
    if (user != null && user.children.isNotEmpty) {
      emit(const ChildrenState.loading());
      try {
        final children = await childRepository.getChildrenForUser(user.userId);
        if (children.isNotEmpty) {
          emit(ChildrenState.hasChildren(children));
        }
      } catch (e) {
        emit(ChildrenState.failure(e.toString()));
      }
    } else {
      emit(const ChildrenState.childless());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
