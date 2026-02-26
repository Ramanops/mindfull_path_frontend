import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/journal_provider.dart';
import '../../models/journal_entry_model.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() =>
      _JournalScreenState();
}

class _JournalScreenState
    extends ConsumerState<JournalScreen> {
  final TextEditingController _controller =
  TextEditingController();

  Future<void> _saveEntry() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    final repo =
    ref.read(journalRepositoryProvider);

    await repo.createEntry(content);

    _controller.clear();

    // 🔄 Refresh list
    ref.refresh(journalProvider);
  }

  @override
  Widget build(BuildContext context) {
    final journalAsync = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Journal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _saveEntry,
              child: const Text("Save Entry"),
            ),

            const SizedBox(height: 20),

            /// 📓 Entries List
            Expanded(
              child: journalAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Center(
                        child: Text("No entries yet"));
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (_, index) {
                      final entry = entries[index];

                      return Card(
                        margin:
                        const EdgeInsets.symmetric(
                            vertical: 8),
                        child: ListTile(
                          title: Text(entry.content),
                          subtitle: Text(
                            entry.createdAt
                                .toLocal()
                                .toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                    child:
                    CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(e.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}