import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/breathing_provider.dart';
import '../../providers/nav_provider.dart';
import '../../widgets/breathing_circle.dart';

class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running = ref.watch(breathingRunningProvider);
    final cycles = ref.watch(breathingCycleProvider);
    final sessionSeconds =
    ref.watch(breathingSessionSecondsProvider);

    String formatTime(int seconds) {
      final m = seconds ~/ 60;
      final s = seconds % 60;
      return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF4F7FF),
              Color(0xFFEDEFFF),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [

              const SizedBox(height: 10),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      ref.read(navIndexProvider.notifier).state = 0;
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Breathing Exercises",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 30),

              const Center(child: BreathingCircle()),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  formatTime(sessionSeconds),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Center(
                child: Text(
                  "Cycle $cycles",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {
                  if (running) {
                    stopBreathingSession(ref);
                  } else {
                    startBreathingSession(ref);
                  }
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF4A90E2),
                        Color(0xFF6C63FF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 20,
                        color: Colors.blue.withOpacity(0.3),
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      running
                          ? "STOP BREATHING"
                          : "START BREATHING",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Breathing Pattern",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _PatternCard(
                        title: "Calm (4-7-8)",
                        inTime: "4s",
                        holdTime: "7s",
                        outTime: "8s",
                        selected: true),
                    SizedBox(width: 16),
                    _PatternCard(
                        title: "Box (4-4-4)",
                        inTime: "4s",
                        holdTime: "4s",
                        outTime: "4s"),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final String title;
  final String inTime;
  final String holdTime;
  final String outTime;
  final bool selected;

  const _PatternCard({
    required this.title,
    required this.inTime,
    required this.holdTime,
    required this.outTime,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: selected
            ? Border.all(color: Colors.blue, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              _miniBox("IN", inTime),
              _miniBox("HOLD", holdTime),
              _miniBox("OUT", outTime),
            ],
          )
        ],
      ),
    );
  }

  Widget _miniBox(String label, String value) {
    return Container(
      width: 55,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}