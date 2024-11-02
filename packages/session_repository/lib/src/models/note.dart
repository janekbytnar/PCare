import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class Note extends Equatable {
  final String noteId;
  final String noteName;
  final String noteDescription;
  final DateTime noteTime;

  const Note({
    required this.noteId,
    required this.noteName,
    required this.noteDescription,
    required this.noteTime,
  });

  static final empty = Note(
    noteId: '',
    noteName: '',
    noteDescription: '',
    noteTime: DateTime(1970, 1, 1, 0, 0, 0),
  );

  Note copyWith({
    String? noteId,
    String? noteName,
    String? noteDescription,
    DateTime? noteTime,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      noteName: noteName ?? this.noteName,
      noteDescription: noteDescription ?? this.noteDescription,
      noteTime: noteTime ?? this.noteTime,
    );
  }

  NoteEntity toEntity() {
    return NoteEntity(
      noteId: noteId,
      noteName: noteName,
      noteDescription: noteDescription,
      noteTime: noteTime,
    );
  }

  static Note fromEntity(NoteEntity entity) {
    return Note(
      noteId: entity.noteId,
      noteName: entity.noteName,
      noteDescription: entity.noteDescription,
      noteTime: entity.noteTime,
    );
  }

  @override
  List<Object?> get props => [
        noteId,
        noteName,
        noteDescription,
        noteTime,
      ];
}
