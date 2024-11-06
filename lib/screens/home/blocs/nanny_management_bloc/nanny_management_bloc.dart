import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nanny_management_event.dart';
part 'nanny_management_state.dart';

class NannyManagementBloc extends Bloc<NannyManagementEvent, NannyManagementState> {
  NannyManagementBloc() : super(NannyManagementInitial()) {
    on<NannyManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
