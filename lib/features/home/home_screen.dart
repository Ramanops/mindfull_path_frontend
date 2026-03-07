import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/nav_provider.dart';
import '../breathing/breathing_screen.dart';
import '../streak/streak_screen.dart';   // 🔥 ADDED
import '../chat/chat_screen.dart';
import '../profile/profile_screen.dart';
import 'home_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawIndex = ref.watch(navIndexProvider);

    // ✅ Updated Pages List (Mood removed, Streak added)
    final pages = [
      const HomeTab(),          // 0
      const BreathingScreen(),  // 1
      const StreakScreen(),     // 2 🔥
      const ChatScreen(),       // 3
      const ProfileScreen(),    // 4
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