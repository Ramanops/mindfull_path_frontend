import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current meditation streak (days)
final streakProvider = StateProvider<int>((ref) => 12);

/// Today's focus category
final focusProvider =
StateProvider<String>((ref) => "Calmness");