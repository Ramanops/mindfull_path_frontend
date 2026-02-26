import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/journal_repository.dart';
import '../core/network/api_client.dart';
import '../models/journal_entry_model.dart';
import '../providers/auth_provider.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return JournalRepository(apiClient);
});

final journalProvider =
FutureProvider<List<JournalEntry>>((ref) async {
  final repository = ref.read(journalRepositoryProvider);
  return repository.fetchEntries();
});