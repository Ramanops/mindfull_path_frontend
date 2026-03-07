import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nav_provider.dart';
import '../../features/streak/streak_provider.dart';

enum BreathPhase { inhale, hold, exhale }

class BreathingPattern {
  final String name;
  final int inhale;
  final int hold;
  final int exhale;

  const BreathingPattern({
    required this.name,
    required this.inhale,
    required this.hold,
    required this.exhale,
  });
}

final patterns = [
  BreathingPattern(name: "Calm (4-7-8)", inhale: 4, hold: 7, exhale: 8),
  BreathingPattern(name: "Box (4-4-4)", inhale: 4, hold: 4, exhale: 4),
];

class BreathingScreen extends ConsumerStatefulWidget {
  const BreathingScreen({super.key});

  @override
  ConsumerState<BreathingScreen> createState() =>
      _BreathingScreenState();
}

class _BreathingScreenState extends ConsumerState<BreathingScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  Timer? _timer;

  final int _totalSeconds = 300;
  int _remainingSeconds = 300;

  BreathPhase _phase = BreathPhase.inhale;
  int _phaseSecondsLeft = 0;

  bool _running = false;
  int _selectedIndex = 0;

  BreathingPattern get pattern => patterns[_selectedIndex];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _setPhase(BreathPhase.inhale);
  }

  void _exitToHome() {
    _timer?.cancel();
    _controller.stop();
    _running = false;
    ref.read(navIndexProvider.notifier).state = 0;
  }

  void _setPhase(BreathPhase phase) {
    _phase = phase;

    int duration;

    if (phase == BreathPhase.inhale) {
      duration = pattern.inhale;
      _controller.duration = Duration(seconds: duration);
      _controller.forward(from: 0);
    } else if (phase == BreathPhase.hold) {
      duration = pattern.hold;
      _controller.stop();
    } else {
      duration = pattern.exhale;
      _controller.duration = Duration(seconds: duration);
      _controller.reverse(from: 1);
    }

    _phaseSecondsLeft = duration;
  }

  void _startBreathing() {
    if (_running) return;

    setState(() {
      _running = true;
      _remainingSeconds = _totalSeconds;
      _setPhase(BreathPhase.inhale);
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        _remainingSeconds--;
        _phaseSecondsLeft--;

        if (_phaseSecondsLeft <= 0) {
          if (_phase == BreathPhase.inhale) {
            _setPhase(BreathPhase.hold);
          } else if (_phase == BreathPhase.hold) {
            _setPhase(BreathPhase.exhale);
          } else {
            _setPhase(BreathPhase.inhale);
          }
        }

        if (_remainingSeconds <= 0) {
          _finishSession();
        }
      });
    });
  }

  void _finishSession() {
    _timer?.cancel();
    _controller.stop();
    _running = false;

    ref
        .read(streakProvider.notifier)
        .completeActivity(ActivityType.breathing);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Session Complete 🌿"),
        content: const Text("Beautiful breathing work today!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _exitToHome();
            },
            child: const Text("Done"),
          )
        ],
      ),
    );
  }

  String get formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return "$m:${s.toString().padLeft(2, '0')}";
  }

  String get phaseText {
    switch (_phase) {
      case BreathPhase.inhale:
        return "INHALE";
      case BreathPhase.hold:
        return "HOLD";
      case BreathPhase.exhale:
        return "EXHALE";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _exitToHome();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5FA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    IconButton(
                      onPressed: _exitToHome,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Breathing",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline)
                  ],
                ),

                const SizedBox(height: 20),

                /// TOP CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black.withValues(alpha: 0.05),
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      const Text(
                        "Find Your Center",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      /// BREATHING ORB WITH PHASE
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (_, __) => Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF8E9FFF),
                                  Color(0xFF6C63FF),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  phaseText,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _phaseSecondsLeft.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// SESSION TIMER
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed:
                        _running ? null : _startBreathing,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("START BREATHING"),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                          const Size.fromHeight(55),
                          backgroundColor:
                          const Color(0xFF6C63FF),
                          foregroundColor:
                          Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// SELECT PATTERN
                const Text(
                  "Select a Pattern",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                Column(
                  children: List.generate(patterns.length, (index) {
                    final selected = index == _selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        if (_running) return;
                        setState(() => _selectedIndex = index);
                      },
                      child: Container(
                        margin:
                        const EdgeInsets.only(bottom: 12),
                        padding:
                        const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE8E9FF)
                              : Colors.white,
                          borderRadius:
                          BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF6C63FF)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                patterns[index].name,
                                style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w600),
                              ),
                            ),
                            if (selected)
                              const Icon(Icons.check,
                                  color:
                                  Color(0xFF6C63FF))
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}