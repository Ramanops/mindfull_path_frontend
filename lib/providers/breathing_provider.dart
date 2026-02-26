import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BreathPhase { inhale, hold, exhale }

final breathingRunningProvider =
StateProvider<bool>((ref) => false);

final breathingPhaseProvider =
StateProvider<BreathPhase>((ref) => BreathPhase.inhale);

final breathingPhaseSecondsProvider =
StateProvider<int>((ref) => 4);

final breathingCycleProvider =
StateProvider<int>((ref) => 0);

final breathingSessionSecondsProvider =
StateProvider<int>((ref) => 300);

Timer? _timer;

void startBreathingSession(WidgetRef ref) {
  stopBreathingSession(ref); // 🔥 Always cancel previous safely

  ref.read(breathingRunningProvider.notifier).state = true;
  ref.read(breathingSessionSecondsProvider.notifier).state = 300;
  ref.read(breathingCycleProvider.notifier).state = 0;
  ref.read(breathingPhaseProvider.notifier).state =
      BreathPhase.inhale;
  ref.read(breathingPhaseSecondsProvider.notifier).state = 4;

  _timer = Timer.periodic(
    const Duration(seconds: 1),
        (_) => _tick(ref),
  );
}

void stopBreathingSession(WidgetRef ref) {
  _timer?.cancel();
  _timer = null;
  ref.read(breathingRunningProvider.notifier).state = false;
}

void _tick(WidgetRef ref) {
  final session =
  ref.read(breathingSessionSecondsProvider);

  if (session <= 0) {
    stopBreathingSession(ref);
    return;
  }

  ref
      .read(breathingSessionSecondsProvider.notifier)
      .state--;

  _updatePhase(ref);
}

void _updatePhase(WidgetRef ref) {
  final phase = ref.read(breathingPhaseProvider);
  final seconds =
  ref.read(breathingPhaseSecondsProvider);

  if (seconds > 1) {
    ref
        .read(breathingPhaseSecondsProvider.notifier)
        .state--;
    return;
  }

  switch (phase) {
    case BreathPhase.inhale:
      ref.read(breathingPhaseProvider.notifier).state =
          BreathPhase.hold;
      ref.read(breathingPhaseSecondsProvider.notifier).state = 7;
      break;

    case BreathPhase.hold:
      ref.read(breathingPhaseProvider.notifier).state =
          BreathPhase.exhale;
      ref.read(breathingPhaseSecondsProvider.notifier).state = 8;
      break;

    case BreathPhase.exhale:
      ref.read(breathingPhaseProvider.notifier).state =
          BreathPhase.inhale;
      ref.read(breathingPhaseSecondsProvider.notifier).state = 4;
      ref.read(breathingCycleProvider.notifier).state++;
      break;
  }
}