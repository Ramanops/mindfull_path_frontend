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
  }

  @override
  Widget build(BuildContext context) {
    final running =
        ref.watch(breathingRunningProvider);
    final phase =
        ref.watch(breathingPhaseProvider);
    final seconds =
        ref.watch(breathingPhaseSecondsProvider);

    if (running) {
      if (phase == BreathPhase.inhale) {
        _controller.duration =
            const Duration(seconds: 4);
        _controller.forward();
      } else if (phase == BreathPhase.exhale) {
        _controller.duration =
            const Duration(seconds: 8);
        _controller.reverse();
      }
    }

    String phaseText = phase.name.toUpperCase();

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
                  color:
                      Colors.blue.withOpacity(0.3),
                )
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    phaseText,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$seconds s",
                    style: const TextStyle(
                        color: Colors.white70),
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