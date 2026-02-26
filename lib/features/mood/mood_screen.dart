import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/mood_provider.dart';
import '../../widgets/pill_selector.dart';
import '../../widgets/chart_widgets.dart';
import '../../widgets/stat_card.dart';

class MoodScreen extends ConsumerWidget {
  const MoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedMoodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            /// Mood Selector
            PillSelector(
              items: moodList,
              selected: selected,
              label: (m) => m.name,
              onSelected: (m) => ref
                  .read(selectedMoodProvider.notifier)
                  .state = m,
            ),

            const SizedBox(height: 24),

            /// Weekly Bar Chart
            WeeklyBarChart(
              values: const [3, 4, 2, 5, 4, 3, 5],
            ),

            const SizedBox(height: 24),

            /// Donut Chart
            const MoodDonutChart(percent: 65),

            const SizedBox(height: 24),

            /// Stats Row
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    title: "Mood Score",
                    value: "8.4",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: "Stability",
                    value: "92%",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}