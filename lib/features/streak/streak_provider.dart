import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActivityType { meditation, breathing }

class StreakState {
  final int currentStreak;
  final DateTime? lastCompletedDate;

  /// Tracks daily activity completion
  final Map<String, Set<ActivityType>> dailyActivities;

  const StreakState({
    required this.currentStreak,
    required this.lastCompletedDate,
    required this.dailyActivities,
  });

  StreakState copyWith({
    int? currentStreak,
    DateTime? lastCompletedDate,
    Map<String, Set<ActivityType>>? dailyActivities,
  }) {
    return StreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      lastCompletedDate:
      lastCompletedDate ?? this.lastCompletedDate,
      dailyActivities:
      dailyActivities ?? this.dailyActivities,
    );
  }
}

class StreakNotifier extends StateNotifier<StreakState> {
  StreakNotifier()
      : super(
    const StreakState(
      currentStreak: 0,
      lastCompletedDate: null,
      dailyActivities: {},
    ),
  );

  String _todayKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  void completeActivity(ActivityType type) {
    final today = DateTime.now();
    final key = _todayKey();

    final activities =
    {...(state.dailyActivities[key] ?? <ActivityType>{})};

    activities.add(type);

    final updatedMap = {
      ...state.dailyActivities,
      key: activities,
    };

    bool dayComplete =
        activities.contains(ActivityType.meditation) &&
            activities.contains(ActivityType.breathing);

    int newStreak = state.currentStreak;
    DateTime? lastDate = state.lastCompletedDate;

    if (dayComplete) {
      if (lastDate == null) {
        newStreak = 1;
      } else {
        final diff = today.difference(lastDate).inDays;

        if (diff == 1) {
          newStreak += 1;
        } else if (diff > 1) {
          newStreak = 1;
        } else {
          // same day → do nothing
        }
      }

      lastDate = today;
    }

    state = state.copyWith(
      currentStreak: newStreak,
      lastCompletedDate: lastDate,
      dailyActivities: updatedMap,
    );
  }

  /// Daily progress (0,1,2)
  int todayProgress() {
    final key = _todayKey();
    return state.dailyActivities[key]?.length ?? 0;
  }

  /// Weekly heatmap data
  Map<DateTime, bool> weeklyHeatmap() {
    final now = DateTime.now();
    final startOfWeek =
    now.subtract(Duration(days: now.weekday - 1));

    Map<DateTime, bool> result = {};

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final key =
          "${day.year}-${day.month}-${day.day}";

      final activities =
          state.dailyActivities[key] ?? {};

      result[day] =
          activities.contains(ActivityType.meditation) &&
              activities.contains(ActivityType.breathing);
    }

    return result;
  }
}

final streakProvider =
StateNotifierProvider<StreakNotifier, StreakState>(
        (ref) => StreakNotifier());