import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'streak_provider.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final weekData = _buildLast7Days(streak);

    // ✅ Theme-aware — no hardcoded background
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final doneColor = const Color(0xFF8B5CF6);
    final emptyColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;

    return Scaffold(
      // ✅ Removed hardcoded Color(0xFFF6F7FB) — now uses theme scaffold color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Text(
                "🔥 ${streak.currentStreak} Day Streak",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface, // ✅ adapts to dark/light
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Weekly Progress",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface, // ✅ adapts
                ),
              ),

              const SizedBox(height: 20),

              // Weekly Heatmap
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekData.map((done) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: done ? doneColor : emptyColor, // ✅ dark-aware empty color
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              Text(
                "${weekData.where((e) => e).length}/7 days completed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface, // ✅ adapts
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  String _dateKey(DateTime date) => "${date.year}-${date.month}-${date.day}";
}