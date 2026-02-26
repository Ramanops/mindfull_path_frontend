import 'package:dio/dio.dart';
import '../core/network/api_client.dart';
import '../models/journal_entry_model.dart';

class JournalRepository {
  final ApiClient api;

  JournalRepository(this.api);

  /// GET entries
  Future<List<JournalEntry>> fetchEntries() async {
    final response = await api.dio.get('/journal');

    final data = response.data;

    if (data is! List) {
      throw Exception('Invalid response format');
    }

    return data
        .map<JournalEntry>((e) => JournalEntry.fromJson(e))
        .toList();
  }

  /// CREATE entry ✅ (This was missing)
  Future<void> createEntry(String content) async {
    await api.dio.post(
      '/journal',
      data: {
        'content': content,
      },
    );
  }
}