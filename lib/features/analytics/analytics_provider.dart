import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../repositories/analytics_repository.dart';
import '../../models/analytics_model.dart';

// ── Range toggle: 7 or 30 days ─────────────────────
final analyticsRangeProvider = StateProvider<int>((ref) => 7);

// ── Repository provider ────────────────────────────
final analyticsRepoProvider = Provider((ref) {
  return AnalyticsRepository(apiClient: ApiClient());
});

// ── Async data provider ────────────────────────────
final analyticsProvider = FutureProvider.autoDispose<AnalyticsSummary>((ref) {
  final days = ref.watch(analyticsRangeProvider);
  final repo = ref.watch(analyticsRepoProvider);
  return repo.getSummary(days: days);
});