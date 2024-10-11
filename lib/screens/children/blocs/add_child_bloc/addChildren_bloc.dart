// lib/screens/children/blocs/children_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:child_repository/child_repository.dart';

part 'addChildren_event.dart';
part 'addChildren_state.dart';

class AddChildrenBloc extends Bloc<AddChildrenEvent, AddChildrenState> {
  final UserRepository userRepository;

  AddChildrenBloc({
    required this.userRepository,
  }) : super(ChildrenInitial()) {
    on<LoadChildrenEvent>(_onLoadChildren);
  }

  Future<void> _onLoadChildren(
      LoadChildrenEvent event, Emitter<AddChildrenState> emit) async {
    emit(ChildrenLoading());
    try {
      // Fetch the current user's data
      final currentUser = await userRepository.getCurrentUserData();
      final children = currentUser!.children;
      emit(ChildrenLoaded(children: []));
    } catch (e) {
      emit(ChildrenError(error: e.toString()));
    }
  }
}
