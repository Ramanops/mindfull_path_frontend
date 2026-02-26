import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);

    final isDark = themeMode == ThemeMode.dark;

    // Safe username extraction
    final userName = (userEmail != null && userEmail.contains('@'))
        ? userEmail.split('@').first
        : "Guest";

    // Safe first letter
    final firstLetter =
    userName.isNotEmpty ? userName[0].toUpperCase() : "G";

    // Premium logic
    final isPremium =
        userEmail != null && userEmail.toLowerCase().contains("pro");

    // Dynamic avatar color
    final avatarColor =
    isPremium ? Colors.amber : Colors.deepPurple;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BACK + TITLE
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).cardColor,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// PROFILE SECTION
              Center(
                child: Column(
                  children: [

                    /// Avatar
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: avatarColor,
                          width: 3,
                        ),
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: avatarColor.withValues(alpha: 0.25),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          firstLetter,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: avatarColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Username
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// Email
                    Text(
                      userEmail ?? "Not logged in",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Premium Badge
                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "🌟 PREMIUM MEMBER",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "ACCOUNT MANAGEMENT",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              _buildTile(context, Icons.person_outline, "Personal Info"),
              _buildTile(context, Icons.notifications_none, "Notifications"),

              /// 🌙 DARK MODE TOGGLE
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      child: Icon(Icons.dark_mode_outlined),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Dark Mode",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (value) {
                        ref
                            .read(themeProvider.notifier)
                            .toggleTheme(value);
                      },
                    ),
                  ],
                ),
              ),

              _buildTile(context, Icons.security, "Privacy & Security"),
              _buildTile(context, Icons.settings, "App Settings"),

              const SizedBox(height: 40),

              /// SIGN OUT
              GestureDetector(
                onTap: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "SIGN OUT",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(
      BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: 0.1),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}