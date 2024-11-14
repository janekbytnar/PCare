import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect_childcare/components/add_dialog.dart';
import 'package:perfect_childcare/components/tile.dart';
import 'package:perfect_childcare/screens/session/blocs/note_management_bloc/note_management_bloc.dart';
import 'package:session_repository/session_repository.dart';

class NoteScreen extends StatefulWidget {
  final List<Note>? note;
  final String sessionId;
  final DateTime endDate;
  const NoteScreen(
      {super.key, this.note, required this.sessionId, required this.endDate});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.activeOrange,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocBuilder<NoteManagementBloc, NoteManagementState>(
        builder: (context, state) {
          if (state is NoteManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteManagementLoaded) {
            final notes = state.notes;
            if (notes.isEmpty) {
              return const Center(child: Text('No notes found.'));
            }
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return CustomTile(
                  title: note.noteName,
                  subtitle: note.noteDescription,
                  onToggleDone: () {},
                  onDelete: () {
                    context.read<NoteManagementBloc>().add(NoteManagementDelete(
                          note.noteId,
                          widget.sessionId,
                        ));
                  },
                );
              },
            );
          } else if (state is NoteManagementError) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
      floatingActionButton: (widget.endDate.isAfter(DateTime.now()))
          ? FloatingActionButton(
              heroTag: 'notesTag',
              backgroundColor: CupertinoColors.activeGreen,
              foregroundColor: CupertinoColors.systemGrey,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              tooltip: "Add note",
              onPressed: () {
                _dialogBuilder(context);
              },
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddDialog(
          title: 'Note',
          onAdd: (name, description) {
            final newNote = Note(
              noteId: '',
              noteName: name,
              noteDescription: description ?? "",
              noteTime: DateTime.now(),
            );
            context.read<NoteManagementBloc>().add(
                  NoteManagementAdd(newNote, widget.sessionId),
                );
          },
        );
      },
    );
  }
}
