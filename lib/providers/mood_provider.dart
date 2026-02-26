import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_model.dart';

final moodList = [
  MoodModel(name: 'Happy', emoji: '😊'),
  MoodModel(name: 'Calm', emoji: '😌'),
  MoodModel(name: 'Anxious', emoji: '😟'),
  MoodModel(name: 'Tired', emoji: '😴'),
];

final selectedMoodProvider = StateProvider<MoodModel>((ref) => moodList[1]);