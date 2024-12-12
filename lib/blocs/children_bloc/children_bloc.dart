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
  StreamSubscription<List<Child>>? _childrenSubscription;

  ChildrenBloc({
    required this.userRepository,
    required this.childRepository,
  }) : super(const ChildrenState.unknown()) {
    _userSubscription =
        userRepository.getCurrentUserDataStream().listen((myUser) {
      add(ChildrenStatusChanged(myUser));
    });
    on<ChildrenStatusChanged>(_onStatusChanged);
    on<ChildrenUpdated>(_onChildrenUpdated);
    on<StopListeningChildren>((event, emit) async {
      await _childrenSubscription?.cancel();
      await _userSubscription.cancel();
      emit(const ChildrenState.childless());
    });
  }

  Future<void> _onStatusChanged(
      ChildrenStatusChanged event, Emitter<ChildrenState> emit) async {
    final user = event.user;
    await _childrenSubscription?.cancel();

    if (user != null) {
      emit(const ChildrenState.loading());
      try {
        final linkedPersonId = user.linkedPerson;

        List<String> parentIds = [user.userId];

        if (linkedPersonId.isNotEmpty) {
          parentIds.add(linkedPersonId);
        }

        // Subscribe to the children stream
        _childrenSubscription = childRepository
            .getChildrenForUserStream(parentIds)
            .listen((children) {
          add(ChildrenUpdated(children));
        }, onError: (error) {
          if (error.toString().contains('permission-denied')) {
            emit(const ChildrenState.childless());
          } else {
            emit(ChildrenState.failure(error.toString()));
          }
        });
      } catch (e) {
        emit(ChildrenState.failure(e.toString()));
      }
    } else {
      emit(const ChildrenState.childless());
    }
  }

  void _onChildrenUpdated(ChildrenUpdated event, Emitter<ChildrenState> emit) {
    final children = event.children;
    if (children.isNotEmpty) {
      emit(ChildrenState.hasChildren(children));
    } else {
      emit(const ChildrenState.childless());
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _childrenSubscription?.cancel();
    return super.close();
  }
}
