import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/nav_provider.dart';
import '../breathing/breathing_screen.dart';
import '../streak/streak_screen.dart';
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import '../analytics/analytics_screen.dart'; // ← ADD THIS
import 'home_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawIndex = ref.watch(navIndexProvider);

    // ✅ CORRECT order — must match destinations below exactly
    final pages = [
      const HomeTab(),          // 0 - Home
      const BreathingScreen(),  // 1 - Breathe
      const StreakScreen(),     // 2 - Streak
      const AnalyticsScreen(),  // 3 - Stats  ← FIXED position
      const ChatScreen(),       // 4 - Chat   ← FIXED position
      const ProfileScreen(),    // 5 - Profile
    ];

    final index = rawIndex.clamp(0, pages.length - 1);

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          ref.read(navIndexProvider.notifier).state = i;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: "Breathe",
          ),
          NavigationDestination(
            icon: Icon(Icons.local_fire_department_outlined),
            selectedIcon: Icon(Icons.local_fire_department),
            label: "Streak",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),  // ← Stats tab
            selectedIcon: Icon(Icons.bar_chart),
            label: "Stats",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: "Chat",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}