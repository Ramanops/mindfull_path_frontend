import '../core/network/api_client.dart';
import '../models/analytics_model.dart';

class AnalyticsRepository {
  final ApiClient apiClient;
  AnalyticsRepository({required this.apiClient});

  Future<AnalyticsSummary> getSummary({int days = 7}) async {
    final data = await apiClient.get('/analytics/summary?days=$days');
    return AnalyticsSummary.fromJson(data);
  }
}
