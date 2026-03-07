import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'streak_provider.dart';

class StreakRepository {
  static const String _key = "streak_data";

  Future<void> save(StreakState state) async {
    final prefs = await SharedPreferences.getInstance();

    final Map<String, dynamic> data = {
      "current": state.currentStreak,
      "last": state.lastCompletedDate?.toIso8601String(),
      "daily": state.dailyActivities.map(
            (key, value) => MapEntry(
          key,
          value.map((e) => e.name).toList(),
        ),
      ),
    };

    await prefs.setString(_key, jsonEncode(data));
  }

  Future<StreakState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return null;

    final decoded = jsonDecode(jsonString);

    final Map<String, dynamic> rawDaily =
    Map<String, dynamic>.from(decoded["daily"] ?? {});

    final Map<String, Set<ActivityType>> parsedDaily = {};

    rawDaily.forEach((key, value) {
      parsedDaily[key] = (value as List)
          .map((e) => ActivityType.values
          .firstWhere((a) => a.name == e))
          .toSet();
    });

    return StreakState(
      currentStreak: decoded["current"] ?? 0,
      lastCompletedDate: decoded["last"] != null
          ? DateTime.parse(decoded["last"])
          : null,
      dailyActivities: parsedDaily,
    );
  }
}