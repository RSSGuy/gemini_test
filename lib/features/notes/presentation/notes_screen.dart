
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/errors/exceptions.dart';
import '../../../l10n/app_localizations.dart';
import '../application/notes_notifier.dart';
import '../data/note_model.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../ai_helper/application/ai_providers.dart';
import '../../ai_helper/data/ai_service.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notesAsync = ref.watch(notesProvider);

    ref.listen<AsyncValue<List<Note>>>(notesProvider, (_, state) {
      if (state is AsyncError) {
        showErrorDialog(context, state.error.toString());
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.myNotes, style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 16),
            Text(l10n.notesDescription, style: Theme.of(context).textTheme.bodyMedium,),
            const SizedBox(height: 24),
            Expanded(
              child: notesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text(err.toString())),
                data: (notes) {
                  if (notes.isEmpty) {
                    return Center(child: Text(l10n.noNotes),);
                  }
                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return Card(
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => ref.read(notesProvider.notifier).deleteNote(noteToDelete: note),
                          ),
                          onTap: () => _showNoteDialog(context, ref, l10n, note: note),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(context, ref, l10n),
        tooltip: l10n.createNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n, {Note? note}) {
    final isCreating = note == null;
    final titleController = TextEditingController(text: note?.title);
    final contentController = TextEditingController(text: note?.content);
    final aiPromptController = TextEditingController();
    final isAiLoading = StateProvider<bool>((ref) => false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCreating ? l10n.createNote : l10n.editNote),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: l10n.title), autofocus: true,),
                const SizedBox(height: 16),
                TextField(controller: contentController, decoration: InputDecoration(labelText: l10n.content), maxLines: 3,),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(l10n.aiHelper, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextField(controller: aiPromptController, decoration: InputDecoration(labelText: l10n.aiPrompt, hintText: l10n.aiPromptHint,),),
                const SizedBox(height: 16),
                Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(isAiLoading);
                      return ElevatedButton.icon(
                        onPressed: isLoading ? null : () async {
                          ref.read(isAiLoading.notifier).state = true;
                          try {
                            final aiService = ref.read(aiServiceProvider);
                            final generatedText = await aiService.generateContent(aiPromptController.text);
                            contentController.text = generatedText;
                          } on AIServiceException catch (e) {
                            if (context.mounted) showErrorDialog(context, e.message);
                          } finally {
                            if(context.mounted) ref.read(isAiLoading.notifier).state = false;
                          }
                        },
                        icon: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white,)) : const Icon(Icons.auto_awesome),
                        label: Text(l10n.generateContent),
                      );
                    }
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel),),
            ElevatedButton(
              onPressed: () {
                print('[DEBUG] Save button was pressed!');
                if (isCreating) {
                  ref.read(notesProvider.notifier).addNote(title: titleController.text, content: contentController.text,);
                } else {
                  ref.read(notesProvider.notifier).updateNote(note: note, newTitle: titleController.text, newContent: contentController.text,);
                }
                Navigator.of(context).pop();
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }
}