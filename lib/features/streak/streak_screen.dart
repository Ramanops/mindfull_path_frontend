import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'streak_provider.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    final weekData = _buildLast7Days(streak);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// 🔥 Current Streak
              Text(
                "🔥 ${streak.currentStreak} Day Streak",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Weekly Progress",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              /// Weekly Heatmap
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekData.map((done) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: done
                          ? const Color(0xFF8B5CF6)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              Text(
                "${weekData.where((e) => e).length}/7 days completed",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds last 7 days heatmap
  List<bool> _buildLast7Days(StreakState state) {
    final today = DateTime.now();
    final List<bool> result = [];

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key = _dateKey(date);

      final activities = state.dailyActivities[key];

      if (activities != null &&
          activities.contains(ActivityType.meditation) &&
          activities.contains(ActivityType.breathing)) {
        result.add(true);
      } else {
        result.add(false);
      }
    }

    return result;
  }

  String _dateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }
}