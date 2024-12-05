import 'package:bloc/bloc.dart';
import 'package:child_repository/child_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_event.dart';
import 'package:perfect_childcare/screens/children/blocs/children_management_bloc/children_management_state.dart';
import 'package:user_repository/user_repository.dart';

class ChildrenManagementBloc
    extends Bloc<ChildrenManagementEvent, ChildrenManagementState> {
  final ChildRepository childRepository;
  final UserRepository userRepository;

  ChildrenManagementBloc({
    required this.childRepository,
    required this.userRepository,
  }) : super(ChildrenManagementInitial()) {
    on<AddChildEvent>(_onAddChild);
    on<RemoveChildEvent>(_onRemoveChild);
    on<UpdateChildEvent>(_onUpdateChild);
  }

  Future<void> _onAddChild(
    AddChildEvent event,
    Emitter<ChildrenManagementState> emit,
  ) async {
    emit(ChildrenManagementLoading());
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const ChildrenManagementFailure('User not logged in'));
        return;
      }
      await childRepository.addChild(event.child);
      // Update user's children list
      await userRepository.connectChildToUser(event.userId, event.child.id);
      final user = await userRepository.getUserById(event.userId);

      if (user != null) {
        final linkedPersonId = user.linkedPerson;
        if (linkedPersonId.isNotEmpty) {
          await userRepository.connectChildToUser(
              linkedPersonId, event.child.id);
        }
      }

      emit(ChildrenManagementSuccess());
    } catch (e) {
      emit(ChildrenManagementFailure(e.toString()));
    }
  }

  Future<void> _onRemoveChild(
      RemoveChildEvent event, Emitter<ChildrenManagementState> emit) async {
    emit(ChildrenManagementLoading());
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const ChildrenManagementFailure('User not logged in'));
        return;
      }
      await userRepository.disconnectChildFromUser(event.childId);
      await childRepository.removeChild(event.childId);

      emit(ChildrenManagementSuccess());
    } catch (e) {
      emit(ChildrenManagementFailure(e.toString()));
    }
  }

  Future<void> _onUpdateChild(
      UpdateChildEvent event, Emitter<ChildrenManagementState> emit) async {
    emit(ChildrenManagementLoading());
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(const ChildrenManagementFailure('User not logged in'));
        return;
      }
      await childRepository.updateChild(event.child);
      emit(ChildrenManagementSuccess());
    } catch (e) {
      emit(ChildrenManagementFailure(e.toString()));
    }
  }
}
