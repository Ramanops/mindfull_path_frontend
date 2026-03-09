import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/analytics_model.dart';
import 'analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(analyticsRangeProvider);
    final asyncData = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Stats'),
        actions: [
          // ── Day range toggle ───────────────────────
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 7, label: Text('7d')),
                ButtonSegment(value: 30, label: Text('30d')),
              ],
              selected: {days},
              onSelectionChanged: (s) =>
                  ref.read(analyticsRangeProvider.notifier).state = s.first,
            ),
          ),
        ],
      ),
      body: asyncData.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (summary) => _buildContent(context, summary),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalyticsSummary s) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // ── Stat tiles row ─────────────────────────
        Row(children: [
          _StatTile('😊 Moods', s.totalMoodEntries.toString()),
          const SizedBox(width: 12),
          _StatTile('📝 Journals', s.totalJournalEntries.toString()),
          const SizedBox(width: 12),
          _StatTile('🔥 Streak', '${s.currentStreak}d'),
        ]),

        const SizedBox(height: 24),

        // ── Mood timeline line chart ───────────────
        _SectionCard(
          title: 'Mood Intensity',
          child: _MoodLineChart(points: s.moodTimeline),
        ),

        const SizedBox(height: 16),

        // ── Journal activity bar chart ─────────────
        _SectionCard(
          title: 'Journal Activity',
          child: _JournalBarChart(activity: s.journalActivity),
        ),

        const SizedBox(height: 16),

        // ── Mood breakdown donut ───────────────────
        if (s.moodBreakdown.isNotEmpty)
          _SectionCard(
            title: 'Mood Breakdown',
            child: _MoodDonut(breakdown: s.moodBreakdown),
          ),

        const SizedBox(height: 16),

        // ── Longest streak tile ────────────────────
        Card(
          child: ListTile(
            leading: const Text('🏆', style: TextStyle(fontSize: 28)),
            title: const Text('Longest Streak'),
            trailing: Text(
              '${s.longestStreak} days',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Helper widgets ─────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label, value;
  const _StatTile(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ]),
      ),
    ),
  );
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        child,
      ]),
    ),
  );
}

class _MoodLineChart extends StatelessWidget {
  final List<DayMoodPoint> points;
  const _MoodLineChart({required this.points});
  @override
  Widget build(BuildContext context) {
    final spots = points
        .asMap()
        .entries
        .where((e) => e.value.avgIntensity != null)
        .map((e) => FlSpot(e.key.toDouble(), e.value.avgIntensity!))
        .toList();
    if (spots.isEmpty) return const Text('No mood data yet.');
    return SizedBox(
      height: 180,
      child: LineChart(LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        minY: 0, maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primary.withOpacity(0.15),
            ),
          ),
        ],
      )),
    );
  }
}

class _JournalBarChart extends StatelessWidget {
  final List<DayJournalCount> activity;
  const _JournalBarChart({required this.activity});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: BarChart(BarChartData(
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      barGroups: activity.asMap().entries.map((e) =>
        BarChartGroupData(x: e.key, barRods: [
          BarChartRodData(
            toY: e.value.count.toDouble(),
            color: AppColors.accentEnd,
            width: 14,
            borderRadius: BorderRadius.circular(6),
          ),
        ])
      ).toList(),
    )),
  );
}

class _MoodDonut extends StatelessWidget {
  final Map<String, int> breakdown;
  const _MoodDonut({required this.breakdown});

  static const moodColors = {
    'Happy': Color(0xFF4ade80),
    'Calm': Color(0xFF60a5fa),
    'Anxious': Color(0xFFfbbf24),
    'Tired': Color(0xFFf87171),
  };

  @override
  Widget build(BuildContext context) {
    final total = breakdown.values.fold(0, (a, b) => a + b);
    return SizedBox(
      height: 180,
      child: PieChart(PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 55,
        sections: breakdown.entries.map((e) => PieChartSectionData(
          value: e.value.toDouble(),
          title: '${(e.value / total * 100).round()}%',
          color: moodColors[e.key] ?? AppColors.primary,
          radius: 55,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        )).toList(),
      )),
    );
  }
}