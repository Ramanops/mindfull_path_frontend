import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/stat_card.dart';
import '../../theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/nav_provider.dart';
import '../../providers/auth_provider.dart';

import '../meditation/meditation_screen.dart';
import '../journal/journal_screen.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(authProvider);

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

          const SizedBox(height: 24),

          /// Question
          Text(
            "How are you feeling today?",
            style: AppTextStyles.body,
          ),

          const SizedBox(height: 24),

          /// Stats Row
          Row(
            children: const [
              Expanded(
                child: StatCard(
                  title: "Current Streak",
                  value: "12 days",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: "Daily Goal",
                  value: "75%",
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// Quick Activities Title
          Text(
            "Quick Activities",
            style: AppTextStyles.headline,
          ),

          const SizedBox(height: 16),

          /// Guided Meditation
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

          /// Breathing Exercise
          _buildActivityTile(
            context,
            icon: Icons.air,
            title: "Breathing Exercise",
            duration: "3–5 min",
            onTap: () {
              ref.read(navIndexProvider.notifier).state = 1;
            },
          ),

          /// Daily Journal
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

          /// Mood Check-in
          _buildActivityTile(
            context,
            icon: Icons.mood,
            title: "Mood Check-in",
            duration: "1 min",
            onTap: () {
              ref.read(navIndexProvider.notifier).state = 2;
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