import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

part 'note_management_event.dart';
part 'note_management_state.dart';

class NoteManagementBloc
    extends Bloc<NoteManagementEvent, NoteManagementState> {
  final SessionRepository sessionRepository;
  StreamSubscription<List<Note>>? _notesSubscription;

  NoteManagementBloc({required this.sessionRepository})
      : super(NoteManagementLoading()) {
    on<LoadNotes>(_onLoadNotes);
    on<NoteManagementUpdated>(_onNotesUpdated);
    on<NoteManagementAdd>(_onAddNote);
    on<NoteManagementUpdate>(_onUpdateNote);
    on<NoteManagementDelete>(_onDeleteNote);
  }
  void _onLoadNotes(LoadNotes event, Emitter<NoteManagementState> emit) {
    _notesSubscription?.cancel();
    _notesSubscription = sessionRepository.getNotes(event.sessionId).listen(
      (notes) {
        add(NoteManagementUpdated(notes, event.sessionId));
      },
      onError: (error) {
        emit(NoteManagementError(error.toString()));
      },
    );
  }

  void _onNotesUpdated(
      NoteManagementUpdated event, Emitter<NoteManagementState> emit) {
    emit(NoteManagementLoaded(event.notes));
  }

  void _onAddNote(
      NoteManagementAdd event, Emitter<NoteManagementState> emit) async {
    await sessionRepository.addNote(event.sessionId, event.note);
  }

  void _onUpdateNote(
      NoteManagementUpdate event, Emitter<NoteManagementState> emit) async {
    try {
      await sessionRepository.updateNote(event.sessionId, event.note);
    } catch (e) {
      emit(NoteManagementError(e.toString()));
    }
  }

  void _onDeleteNote(
      NoteManagementDelete event, Emitter<NoteManagementState> emit) async {
    try {
      await sessionRepository.deleteNote(event.sessionId, event.noteId);
    } catch (e) {
      emit(NoteManagementError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _notesSubscription?.cancel();
    return super.close();
  }
}
