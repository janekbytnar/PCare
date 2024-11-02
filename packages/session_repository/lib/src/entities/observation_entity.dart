import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:session_repository/session_repository.dart';

class NoteEntity extends Equatable {
  final String noteId;
  final String noteName;
  final String noteDescription;
  final DateTime noteTime;

  const NoteEntity({
    required this.noteId,
    required this.noteName,
    required this.noteDescription,
    required this.noteTime,
  });

  Map<String, Object?> toDocument() {
    return {
      'noteId': noteId,
      'noteName': noteName,
      'noteDescription': noteDescription,
      'noteTime': Timestamp.fromDate(noteTime),
    };
  }

  static NoteEntity fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteEntity(
      noteId: data['noteId'] ?? '',
      noteName: data['noteName'] ?? '',
      noteDescription: data['noteDescription'] ?? '',
      noteTime: (data['noteTime'] as Timestamp).toDate(),
    );
  }

  Note toModel() {
    return Note(
      noteId: noteId,
      noteName: noteName,
      noteDescription: noteDescription,
      noteTime: noteTime,
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
