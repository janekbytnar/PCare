part of 'note_management_bloc.dart';

sealed class NoteManagementState extends Equatable {
  const NoteManagementState();

  @override
  List<Object?> get props => [];
}

final class NoteManagementLoading extends NoteManagementState {}

class NoteManagementLoaded extends NoteManagementState {
  final List<Note> notes;

  const NoteManagementLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteManagementError extends NoteManagementState {
  final String error;

  const NoteManagementError(this.error);

  @override
  List<Object?> get props => [error];
}
