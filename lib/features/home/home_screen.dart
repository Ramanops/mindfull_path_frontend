import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nav_provider.dart';
import '../breathing/breathing_screen.dart';
import '../mood/mood_screen.dart';
import '../profile/profile_screen.dart'; // ✅ FIXED IMPORT
import 'home_tab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final rawIndex = ref.watch(navIndexProvider);

    final pages = [
      const HomeTab(),          // 0
      const BreathingScreen(),  // 1
      const MoodScreen(),       // 2
      const ProfileScreen(),    // 3 ✅ FIXED
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
              icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.self_improvement),
              label: "Breathe"),
          NavigationDestination(
              icon: Icon(Icons.mood), label: "Mood"),
          NavigationDestination(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}