part of 'note_management_bloc.dart';

sealed class NoteManagementEvent extends Equatable {
  const NoteManagementEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteManagementEvent {
  final String sessionId;

  const LoadNotes(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class NoteManagementUpdated extends NoteManagementEvent {
  final List<Note> notes;
  final String sessionId;

  const NoteManagementUpdated(this.notes, this.sessionId);

  @override
  List<Object?> get props => [notes];
}

class NoteManagementAdd extends NoteManagementEvent {
  final Note note;
  final String sessionId;

  const NoteManagementAdd(this.note, this.sessionId);

  @override
  List<Object?> get props => [note];
}

class NoteManagementUpdate extends NoteManagementEvent {
  final Note note;
  final String sessionId;

  const NoteManagementUpdate(this.note, this.sessionId);

  @override
  List<Object?> get props => [note];
}

class NoteManagementDelete extends NoteManagementEvent {
  final String noteId;
  final String sessionId;

  const NoteManagementDelete(this.noteId, this.sessionId);

  @override
  List<Object?> get props => [noteId];
}
