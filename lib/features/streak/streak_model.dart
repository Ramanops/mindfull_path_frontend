import 'package:flutter/foundation.dart';

class StreakState {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastCompletedDate;
  final Map<DateTime, bool> weekProgress;

  const StreakState({
    required this.currentStreak,
    required this.longestStreak,
    required this.lastCompletedDate,
    required this.weekProgress,
  });

  factory StreakState.initial() {
    return const StreakState(
      currentStreak: 0,
      longestStreak: 0,
      lastCompletedDate: null,
      weekProgress: {},
    );
  }

  StreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastCompletedDate,
    Map<DateTime, bool>? weekProgress,
  }) {
    return StreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastCompletedDate:
      lastCompletedDate ?? this.lastCompletedDate,
      weekProgress: weekProgress ?? this.weekProgress,
    );
  }
}