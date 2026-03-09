import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mood_provider.dart';
import '../../features/streak/streak_provider.dart';
import '../../models/mood_model.dart';
import '../../core/network/api_client.dart';

import '../meditation/meditation_screen.dart';
import '../journal/journal_screen.dart';
import '../mood/mood_checkin_screen.dart';

// Extended mood list to match Figma design
final homeMoodList = [
  MoodModel(name: 'Happy', emoji: '😄'),
  MoodModel(name: 'Calm', emoji: '😌'),
  MoodModel(name: 'Stressed', emoji: '😫'),
  MoodModel(name: 'Anxious', emoji: '😰'),
  MoodModel(name: 'Angry', emoji: '😡'),
  MoodModel(name: 'Tired', emoji: '🥱'),
  MoodModel(name: 'Overwhelmed', emoji: '🤯'),
  MoodModel(name: 'Motivated', emoji: '🔥'),
];

// Tracks which mood is tapped on home screen
final homeMoodSelectedProvider = StateProvider<String?>((ref) => null);
// Tracks daily mindfulness minutes (local mock — replace with real API later)
final mindfulMinutesProvider = StateProvider<int>((ref) => 0);

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(authProvider);
    final streakState = ref.watch(streakProvider);
    final selectedMood = ref.watch(homeMoodSelectedProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Extract first name from email
    final displayName = userEmail != null && userEmail.contains('@')
        ? userEmail.split('@')[0]
        : 'there';

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── HERO HEADER (purple gradient) ─────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF9B59B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App name + greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MindFull Path',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Welcome back! 👋',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── MOOD EMOJI ROW ─────────────────────────────────
                const Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: homeMoodList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final mood = homeMoodList[index];
                      final isSelected = selectedMood == mood.name;
                      return GestureDetector(
                        onTap: () async {
                          ref.read(homeMoodSelectedProvider.notifier).state =
                              mood.name;
                          // Save mood with default intensity 5
                          try {
                            await ApiClient().post('/moods', {
                              'moodType': mood.name,
                              'intensity': 5,
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${mood.emoji} ${mood.name} mood saved!'),
                                  backgroundColor: const Color(0xFF6C63FF),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (_) {}
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.white30,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(mood.emoji,
                                  style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 6),
                              Text(
                                mood.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? const Color(0xFF6C63FF)
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── DAILY PROGRESS + STREAK ROW ───────────────────
                Row(
                  children: [
                    // Daily Progress card
                    Expanded(
                      child: _DailyProgressCard(),
                    ),
                    const SizedBox(width: 14),
                    // Streak card
                    Expanded(
                      child: _StreakCard(streak: streakState.currentStreak),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── QUICK ACTIVITIES ──────────────────────────────
                const Text(
                  'Quick Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                _ActivityTile(
                  icon: Icons.self_improvement,
                  iconColor: const Color(0xFF6C63FF),
                  iconBg: const Color(0xFFEEEDFF),
                  title: 'Guided Meditation',
                  subtitle: '10–20 min',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MeditationScreen())),
                ),

                _ActivityTile(
                  icon: Icons.air,
                  iconColor: const Color(0xFF06B6D4),
                  iconBg: const Color(0xFFE0F7FA),
                  title: 'Breathing Exercise',
                  subtitle: '3–5 min',
                  onTap: () => ref.read(navIndexProvider.notifier).state = 1,
                ),

                _ActivityTile(
                  icon: Icons.menu_book_rounded,
                  iconColor: const Color(0xFF10B981),
                  iconBg: const Color(0xFFD1FAE5),
                  title: 'Daily Journal',
                  subtitle: '5 min',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const JournalScreen())),
                ),

                _ActivityTile(
                  icon: Icons.mood,
                  iconColor: const Color(0xFFF59E0B),
                  iconBg: const Color(0xFFFEF3C7),
                  title: 'Mood Check-in',
                  subtitle: '1 min',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MoodCheckinScreen())),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── DAILY PROGRESS CARD ────────────────────────────────────────────
class _DailyProgressCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minutes = ref.watch(mindfulMinutesProvider);
    final goal = 60;
    final progress = (minutes / goal).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2035) : const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Circular progress indicator
              SizedBox(
                width: 36,
                height: 36,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3.5,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
                    ),
                    Center(
                      child: Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mindfulness\nMinutes',
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Text(
            '$minutes/$goal min',
            style: const TextStyle(
              color: Color(0xFF6C63FF),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ── STREAK CARD ────────────────────────────────────────────────────
class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C42), Color(0xFFFF5F1F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'OVERALL\nWELLNESS STREAK',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              Text('🔥', style: TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$streak',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const Text(
            'days',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              streak == 0 ? '🌱 Start your journey!' : '🏆 Keep it up!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ACTIVITY TILE ──────────────────────────────────────────────────
class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActivityTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E2035) : Colors.white;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Colored icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? iconColor.withOpacity(0.2) : iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: subtitleColor)),
                ],
              ),
            ),
            // Arrow
            Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
