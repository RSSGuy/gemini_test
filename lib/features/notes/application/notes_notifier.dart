import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/firebase/firebase_providers.dart';
import '../../../core/errors/exceptions.dart';
import '../data/note_model.dart';

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(() {
  return NotesNotifier();
});

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() async {
    final dbService = ref.read(databaseServiceProvider);
    print(dbService.getNotes());
    return dbService.getNotes();
  }

  Future<void> addNote({required String title, required String content}) async {
    final dbService = ref.read(databaseServiceProvider);
    print('Current user UID: ${dbService.uid}');
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await dbService.createNote(title: title, content: content);
      print(dbService.getNotes());
      return dbService.getNotes();
    });
  }

  Future<void> updateNote({required Note note, required String newTitle, required String newContent}) async {
    final dbService = ref.read(databaseServiceProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await dbService.updateNote(noteId: note.id, title: newTitle, content: newContent);
      print(dbService);
      return dbService.getNotes();
    });
  }

  Future<void> deleteNote({required Note noteToDelete}) async {
    final dbService = ref.read(databaseServiceProvider);
    final previousState = state.valueOrNull ?? [];
    state = AsyncValue.data(
        previousState.where((note) => note.id != noteToDelete.id).toList()
    );

    try {
      await dbService.deleteNote(noteId: noteToDelete.id);
    } catch (e) {
      state = AsyncValue.data(previousState);
      throw DatabaseException('Failed to delete note. Please try again.');
    }
  }

}