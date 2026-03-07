import 'package:flutter_riverpod/flutter_riverpod.dart';

final meditationDurationProvider =
StateProvider<int>((ref) => 5);

final meditationRunningProvider =
StateProvider<bool>((ref) => false);

final focusProvider =
StateProvider<String>((ref) => "Calm Mind");