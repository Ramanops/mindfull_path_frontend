import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/meditation_provider.dart';
import '../../providers/stats_provider.dart';

class MeditationScreen extends ConsumerStatefulWidget {
  const MeditationScreen({super.key});

  @override
  ConsumerState<MeditationScreen> createState() =>
      _MeditationScreenState();
}

class _MeditationScreenState
    extends ConsumerState<MeditationScreen>
    with TickerProviderStateMixin {

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
      duration: const Duration(seconds: 4),
      lowerBound: 0.95,
      upperBound: 1.05,
    );
  }

  void _exitMeditation() {
    _timer?.cancel();
    _glowController.stop();
    ref.read(meditationRunningProvider.notifier).state = false;

    if (mounted) {
      Navigator.pop(context);
    }
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

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        if (_remainingSeconds <= 0) {
          timer.cancel();
          _glowController.stop();
          ref.read(meditationRunningProvider.notifier).state = false;

          ref.read(streakProvider.notifier).state++;
          ref.read(focusProvider.notifier).state = "Deep Focus";
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
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
    ref.read(meditationRunningProvider.notifier).state = false;

    setState(() {
      _remainingSeconds = minutes * 60;
    });
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
    final streak = ref.watch(streakProvider);
    final focus = ref.watch(focusProvider);

    final totalSeconds = selectedMinutes * 60;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1220),
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [

              /// TOP BAR
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white),
                    onPressed: _exitMeditation,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Meditation",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert,
                      color: Colors.white70),
                ],
              ),

              const SizedBox(height: 30),

              /// TIMER
              Center(
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (_, __) {
                    return Transform.scale(
                      scale: _glowController.value,
                      child: Container(
                        height: 260,
                        width: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6)
                                  .withOpacity(0.4),
                              blurRadius: 40,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: CustomPaint(
                          painter:
                          _CircleProgressPainter(
                            progress:
                            _progress(totalSeconds),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  _formatTime(
                                      _remainingSeconds),
                                  style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isRunning
                                      ? "STAY FOCUSED"
                                      : "READY TO BEGIN",
                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white54,
                                    letterSpacing: 2,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// DURATION SELECTOR
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [1, 5, 10, 15].map((m) {
                  final selected =
                      selectedMinutes == m;

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(
                          meditationDurationProvider
                              .notifier)
                          .state = m;
                      _resetTimer();
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(
                            0xFF8B5CF6)
                            : Colors.transparent,
                        borderRadius:
                        BorderRadius.circular(
                            20),
                        border: Border.all(
                            color:
                            Colors.white24),
                      ),
                      child: Text(
                        "${m}m",
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : Colors.white54,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              /// CONTROLS
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  _smallCircleButton(
                      Icons.refresh,
                      _resetTimer),
                  _bigPlayButton(isRunning),
                  _smallCircleButton(
                      Icons.info_outline,
                          () {}),
                ],
              ),

              const Spacer(),

              /// STATS
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  _StatItem(
                    title: "CURRENT STREAK",
                    value: "$streak Days",
                  ),
                  _StatItem(
                    title: "TODAY'S FOCUS",
                    value: focus,
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _smallCircleButton(
      IconData icon, VoidCallback onTap) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
        Border.all(color: Colors.white24),
      ),
      child: IconButton(
        icon: Icon(icon,
            color: Colors.white70),
        onPressed: onTap,
      ),
    );
  }

  Widget _bigPlayButton(bool isRunning) {
    return Container(
      height: 80,
      width: 80,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(
          isRunning
              ? Icons.pause
              : Icons.play_arrow,
          size: 40,
          color: const Color(0xFF8B5CF6),
        ),
        onPressed:
        isRunning ? _pauseTimer : _startTimer,
      ),
    );
  }
}

class _CircleProgressPainter
    extends CustomPainter {
  final double progress;

  _CircleProgressPainter(
      {required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final center =
    Offset(size.width / 2,
        size.height / 2);
    final radius =
        size.width / 2 - strokeWidth;

    final bgPaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = const Color(0xFF8B5CF6)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
        center, radius, bgPaint);

    canvas.drawArc(
      Rect.fromCircle(
          center: center,
          radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _CircleProgressPainter
      oldDelegate) =>
      oldDelegate.progress != progress;
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ],
    );
  }
}