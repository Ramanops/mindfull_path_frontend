import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';
import '../../features/streak/streak_provider.dart';

import '../meditation/meditation_screen.dart';
import '../journal/journal_screen.dart';
import '../mood/mood_checkin_screen.dart'; // ← we'll create this simple wrapper

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(authProvider);
    final streakState = ref.watch(streakProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          const SizedBox(height: 20),

          /// 👋 Welcome Section
          const Text(
            "Welcome 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            userEmail ?? "",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          /// 🔥 Streak
          Text(
            "🔥 ${streakState.currentStreak} day streak",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 30),

          /// Question
          Text(
            "How are you feeling today?",
            style: AppTextStyles.body,
          ),

          const SizedBox(height: 32),

          /// Quick Activities
          Text(
            "Quick Activities",
            style: AppTextStyles.headline,
          ),

          const SizedBox(height: 16),

          _buildActivityTile(
            context,
            icon: Icons.self_improvement,
            title: "Guided Meditation",
            duration: "10–20 min",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MeditationScreen(),
                ),
              );
            },
          ),

          _buildActivityTile(
            context,
            icon: Icons.air,
            title: "Breathing Exercise",
            duration: "3–5 min",
            onTap: () {
              ref.read(navIndexProvider.notifier).state = 1; // Breathe tab
            },
          ),

          _buildActivityTile(
            context,
            icon: Icons.book,
            title: "Daily Journal",
            duration: "5 min",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const JournalScreen(),
                ),
              );
            },
          ),

          _buildActivityTile(
            context,
            icon: Icons.mood,
            title: "Mood Check-in",
            duration: "1 min",
            onTap: () {
              // ✅ FIXED: opens mood screen as a modal, not nav tab
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoodCheckinScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildActivityTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String duration,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(title),
        subtitle: Text(duration),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
