import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/meditation_provider.dart';
import '../../features/streak/streak_provider.dart';

class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() =>
      _MeditationScreenState();
}

class _MeditationScreenState
    extends ConsumerState<MeditationScreen>
    with SingleTickerProviderStateMixin {

  Timer? _timer;
  int _remainingSeconds = 0;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    final minutes = ref.read(meditationDurationProvider);
    _remainingSeconds = minutes * 60;

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      lowerBound: 0.96,
      upperBound: 1.04,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    final totalSeconds =
        ref.read(meditationDurationProvider) * 60;

    if (_remainingSeconds <= 0) {
      _remainingSeconds = totalSeconds;
    }

    ref.read(meditationRunningProvider.notifier).state = true;
    _glowController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
        _glowController.stop();
        ref.read(meditationRunningProvider.notifier).state = false;

        ref
            .read(streakProvider.notifier)
            .completeActivity(ActivityType.meditation);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    _glowController.stop();
    ref.read(meditationRunningProvider.notifier).state = false;
  }

  void _resetTimer() {
    _timer?.cancel();
    _glowController.stop();
    final minutes = ref.read(meditationDurationProvider);
    setState(() => _remainingSeconds = minutes * 60);
    ref.read(meditationRunningProvider.notifier).state = false;
  }

  double _progress(int totalSeconds) {
    if (totalSeconds == 0) return 0;
    return 1 - (_remainingSeconds / totalSeconds);
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMinutes =
    ref.watch(meditationDurationProvider);
    final isRunning =
    ref.watch(meditationRunningProvider);

    final totalSeconds = selectedMinutes * 60;

    return Scaffold(
      backgroundColor: const Color(0xFF0E1220),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              /// 🔙 TOP BAR
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Meditation",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert,
                      color: Colors.white70),
                ],
              ),

              const SizedBox(height: 40),

              /// 🟣 TIMER RING
              AnimatedBuilder(
                animation: _glowController,
                builder: (_, __) => Transform.scale(
                  scale: isRunning ? _glowController.value : 1,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: isRunning
                          ? [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6)
                              .withValues(alpha: 0.5),
                          blurRadius: 80,
                          spreadRadius: 20,
                        )
                      ]
                          : [],
                    ),
                    child: CustomPaint(
                      painter: _RingPainter(
                        progress: _progress(totalSeconds),
                      ),
                      child: Center(
                        child: Container(
                          height: 240,
                          width: 240,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF151A2D),
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatTime(_remainingSeconds),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isRunning
                                    ? "STAY FOCUSED"
                                    : "READY TO BEGIN",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// SELECT LABEL
              const Text(
                "SELECT DURATION",
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    letterSpacing: 2),
              ),

              const SizedBox(height: 20),

              /// ⏱ DURATION SELECTOR
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [1, 5, 10, 15].map((m) {
                  final selected = selectedMinutes == m;

                  return GestureDetector(
                    onTap: () {
                      ref.read(
                          meditationDurationProvider.notifier)
                          .state = m;
                      _resetTimer();
                    },
                    child: AnimatedContainer(
                      duration:
                      const Duration(milliseconds: 250),
                      width: 65,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF8B5CF6)
                            : Colors.transparent,
                        borderRadius:
                        BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF8B5CF6)
                              : Colors.white12,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${m}m",
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 35),

              /// ▶ CONTROLS
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  _circleIcon(Icons.refresh, _resetTimer),
                  GestureDetector(
                    onTap:
                    isRunning ? _pauseTimer : _startTimer,
                    child: Container(
                      height: 85,
                      width: 85,
                      decoration:
                      const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        isRunning
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 42,
                        color:
                        const Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                  _circleIcon(Icons.info_outline, () {}),
                ],
              ),

              const SizedBox(height: 50),

              /// 🧠 Meditation Tips Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A2D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Meditation Tips",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Find a comfortable position. Focus on your breath. "
                          "If your mind wanders, gently bring it back.",
                      style: TextStyle(
                          color: Colors.white54,
                          height: 1.5),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(
      IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child:
        Icon(icon, color: Colors.white70),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center =
    Offset(size.width / 2, size.height / 2);
    final radius =
        size.width / 2 - strokeWidth;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white10
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final gradient = const LinearGradient(
      colors: [
        Color(0xFF8B5CF6),
        Color(0xFF6366F1),
      ],
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(
      covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}