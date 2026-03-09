class DayMoodPoint {
  final String date;
  final double? avgIntensity;
  const DayMoodPoint({required this.date, this.avgIntensity});
  factory DayMoodPoint.fromJson(Map<String, dynamic> j) =>
      DayMoodPoint(date: j['date'], avgIntensity: j['avgIntensity']?.toDouble());
}

class DayJournalCount {
  final String date;
  final int count;
  const DayJournalCount({required this.date, required this.count});
  factory DayJournalCount.fromJson(Map<String, dynamic> j) =>
      DayJournalCount(date: j['date'], count: j['count'] ?? 0);
}

class AnalyticsSummary {
  final List<DayMoodPoint> moodTimeline;
  final Map<String, int> moodBreakdown;
  final List<DayJournalCount> journalActivity;
  final int totalMoodEntries;
  final int totalJournalEntries;
  final double avgMoodIntensity;
  final int currentStreak;
  final int longestStreak;

  const AnalyticsSummary({
    required this.moodTimeline,
    required this.moodBreakdown,
    required this.journalActivity,
    required this.totalMoodEntries,
    required this.totalJournalEntries,
    required this.avgMoodIntensity,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> j) {
    return AnalyticsSummary(
      moodTimeline: (j['moodTimeline'] as List)
          .map((e) => DayMoodPoint.fromJson(e))
          .toList(),
      moodBreakdown: Map<String, int>.from(
          (j['moodBreakdown'] as Map).map((k, v) => MapEntry(k, v as int))),
      journalActivity: (j['journalActivity'] as List)
          .map((e) => DayJournalCount.fromJson(e))
          .toList(),
      totalMoodEntries: j['totalMoodEntries'] ?? 0,
      totalJournalEntries: j['totalJournalEntries'] ?? 0,
      avgMoodIntensity: (j['avgMoodIntensity'] ?? 0).toDouble(),
      currentStreak: j['currentStreak'] ?? 0,
      longestStreak: j['longestStreak'] ?? 0,
    );
  }
}