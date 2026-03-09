import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import 'personal_info_screen.dart';
import 'notifications_screen.dart';
import 'privacy_security_screen.dart';
import 'app_settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final userName = (userEmail != null && userEmail.contains('@'))
        ? userEmail.split('@').first
        : 'Guest';
    final firstLetter = userName.isNotEmpty ? userName[0].toUpperCase() : 'G';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 28),

            // ── AVATAR + NAME ──────────────────────────────────────
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100, width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF6C63FF), width: 3),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.25),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(firstLetter,
                          style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6C63FF))),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(userName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(userEmail ?? 'Not logged in',
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500)),
                ],
              ),
            ),

            const SizedBox(height: 36),

            // ── ACCOUNT MANAGEMENT ─────────────────────────────────
            const Text('ACCOUNT MANAGEMENT',
                style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey)),

            const SizedBox(height: 12),

            _ProfileTile(
              icon: Icons.person_outline,
              iconColor: const Color(0xFF6C63FF),
              title: 'Personal Info',
              subtitle: 'Name, email, password',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PersonalInfoScreen(email: userEmail ?? ''))),
            ),

            _ProfileTile(
              icon: Icons.notifications_none,
              iconColor: const Color(0xFF10B981),
              title: 'Notifications',
              subtitle: 'Reminders & alerts',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen())),
            ),

            // ── DARK MODE TOGGLE ───────────────────────────────────
            _DarkModeTile(isDark: isDark, ref: ref),

            _ProfileTile(
              icon: Icons.security,
              iconColor: const Color(0xFFF59E0B),
              title: 'Privacy & Security',
              subtitle: 'Data & account security',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PrivacySecurityScreen())),
            ),

            _ProfileTile(
              icon: Icons.settings_outlined,
              iconColor: const Color(0xFF06B6D4),
              title: 'App Settings',
              subtitle: 'Language, theme, cache',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AppSettingsScreen())),
            ),

            const SizedBox(height: 32),

            // ── SIGN OUT ───────────────────────────────────────────
            GestureDetector(
              onTap: () => _confirmSignOut(context, ref),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: const Center(
                  child: Text('SIGN OUT',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          letterSpacing: 1)),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ── PROFILE TILE ───────────────────────────────────────────────────
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon, required this.iconColor,
    required this.title, required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 8, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

// ── DARK MODE TILE ─────────────────────────────────────────────────
class _DarkModeTile extends StatelessWidget {
  final bool isDark;
  final WidgetRef ref;
  const _DarkModeTile({required this.isDark, required this.ref});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E2035) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.2 : 0.05),
              blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.dark_mode_outlined,
                color: Color(0xFF8B5CF6), size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dark Mode',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                Text('Switch app appearance',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: isDark,
            activeColor: const Color(0xFF6C63FF),
            onChanged: (v) => ref.read(themeProvider.notifier).toggleTheme(v),
          ),
        ],
      ),
    );
  }
}