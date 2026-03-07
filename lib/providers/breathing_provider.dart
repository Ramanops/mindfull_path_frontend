import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BreathPhase { inhale, hold, exhale }

final breathingProvider =
StateNotifierProvider<BreathingNotifier, BreathingState>(
      (ref) => BreathingNotifier(),
);

class BreathingState {
  final bool isRunning;
  final BreathPhase phase;
  final int phaseSeconds;
  final int cycle;
  final int sessionSeconds;

  const BreathingState({
    required this.isRunning,
    required this.phase,
    required this.phaseSeconds,
    required this.cycle,
    required this.sessionSeconds,
  });

  factory BreathingState.initial() {
    return const BreathingState(
      isRunning: false,
      phase: BreathPhase.inhale,
      phaseSeconds: 4,
      cycle: 0,
      sessionSeconds: 300, // 5 minutes
    );
  }

  BreathingState copyWith({
    bool? isRunning,
    BreathPhase? phase,
    int? phaseSeconds,
    int? cycle,
    int? sessionSeconds,
  }) {
    return BreathingState(
      isRunning: isRunning ?? this.isRunning,
      phase: phase ?? this.phase,
      phaseSeconds: phaseSeconds ?? this.phaseSeconds,
      cycle: cycle ?? this.cycle,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
    );
  }
}

class BreathingNotifier extends StateNotifier<BreathingState> {
  Timer? _timer;
  DateTime? _sessionStart;
  DateTime? _phaseStart;

  static const int _totalSessionSeconds = 300;

  BreathingNotifier() : super(BreathingState.initial());

  // ---------------- START ----------------

  void startSession() {
    if (state.isRunning || _timer != null) return;

    _sessionStart = DateTime.now();
    _phaseStart = DateTime.now();

    state = BreathingState.initial().copyWith(isRunning: true);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _tick(),
    );
  }

  // ---------------- TICK ----------------

  void _tick() {
    if (!mounted || _sessionStart == null || _phaseStart == null) return;

    final now = DateTime.now();

    final sessionElapsed = now.difference(_sessionStart!).inSeconds;
    final remainingSession =
    (_totalSessionSeconds - sessionElapsed).clamp(0, _totalSessionSeconds);

    if (remainingSession <= 0) {
      stopSession();
      return;
    }

    final phaseDuration = _getPhaseDuration(state.phase);
    final phaseElapsed = now.difference(_phaseStart!).inSeconds;

    BreathPhase newPhase = state.phase;
    int newCycle = state.cycle;
    int newPhaseSeconds;

    if (phaseElapsed >= phaseDuration) {
      // Phase completed — advance to next
      newPhase = _nextPhase(state.phase);
      _phaseStart = DateTime.now();
      // FIX: always start new phase at full duration (never 0 or negative)
      newPhaseSeconds = _getPhaseDuration(newPhase);

      if (newPhase == BreathPhase.inhale && state.phase == BreathPhase.exhale) {
        newCycle++;
      }
    } else {
      // FIX: clamp to minimum 1 so animation controller never gets <= 0
      newPhaseSeconds = (phaseDuration - phaseElapsed).clamp(1, phaseDuration);
    }

    state = state.copyWith(
      sessionSeconds: remainingSession,
      phase: newPhase,
      phaseSeconds: newPhaseSeconds,
      cycle: newCycle,
    );
  }

  // ---------------- HELPERS ----------------

  BreathPhase _nextPhase(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return BreathPhase.hold;
      case BreathPhase.hold:
        return BreathPhase.exhale;
      case BreathPhase.exhale:
        return BreathPhase.inhale;
    }
  }

  int _getPhaseDuration(BreathPhase phase) {
    switch (phase) {
      case BreathPhase.inhale:
        return 4;
      case BreathPhase.hold:
        return 7;
      case BreathPhase.exhale:
        return 8;
    }
  }

  // ---------------- STOP ----------------

  void stopSession() {
    _timer?.cancel();
    _timer = null;
    _sessionStart = null;
    _phaseStart = null;

    if (mounted) {
      state = state.copyWith(isRunning: false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}