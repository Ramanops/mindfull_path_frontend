import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/breathing_provider.dart';

class BreathingCircle extends ConsumerStatefulWidget {
  const BreathingCircle({super.key});

  @override
  ConsumerState<BreathingCircle> createState() =>
      _BreathingCircleState();
}

class _BreathingCircleState
    extends ConsumerState<BreathingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
      lowerBound: 0.85,
      upperBound: 1.15,
    );

    // ✅ Listen to state changes OUTSIDE of build() using the new
    // single breathingProvider. We use a selector on `phase` so this
    // listener only fires when the phase changes — not on every
    // seconds tick — keeping animation starts to exactly once per phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(
        breathingProvider.select((s) => s.phase),
            (previous, phase) {
          // Guard: don't animate if session has already stopped
          if (!ref.read(breathingProvider).isRunning) return;
          // Guard: don't re-trigger if phase didn't actually change
          if (previous == phase) return;

          switch (phase) {
            case BreathPhase.inhale:
              _controller.duration = const Duration(seconds: 4);
              _controller.forward();
              break;
            case BreathPhase.hold:
            // Circle stays expanded during hold
              _controller.stop();
              break;
            case BreathPhase.exhale:
              _controller.duration = const Duration(seconds: 8);
              _controller.reverse();
              break;
          }
        },
      );

      // ✅ Listen to isRunning so we smoothly reset when session ends
      ref.listenManual(
        breathingProvider.select((s) => s.isRunning),
            (previous, isRunning) {
          if (!isRunning) {
            _controller.stop();
            _controller.animateTo(
              _controller.lowerBound,
              duration: const Duration(milliseconds: 600),
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Select only the two fields this widget needs to render.
    // Rebuilds only when phase or phaseSeconds changes — not isRunning,
    // cycle, sessionSeconds, etc.
    final phase = ref.watch(breathingProvider.select((s) => s.phase));
    final seconds = ref.watch(breathingProvider.select((s) => s.phaseSeconds));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _controller.value,
          child: Container(
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF6C63FF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 40,
                  spreadRadius: 10,
                  color: Colors.blue.withOpacity(0.3),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    phase.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$seconds s",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}