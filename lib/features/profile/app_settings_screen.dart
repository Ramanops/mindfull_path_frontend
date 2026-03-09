import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});
  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  String _language = 'English';
  String _sessionGoal = '30 min';
  bool _soundEffects = true;
  bool _hapticFeedback = true;
  bool _autoPlay = false;

  final _languages = ['English', 'Hindi', 'Spanish', 'French', 'German'];
  final _sessionGoals = ['15 min', '30 min', '45 min', '60 min'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('App Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionLabel('PREFERENCES'),

          // Language selector
          _DropdownTile(
            isDark: isDark,
            icon: Icons.language_outlined,
            iconColor: const Color(0xFF6C63FF),
            title: 'Language',
            value: _language,
            items: _languages,
            onChanged: (v) => setState(() => _language = v!),
          ),

          // Session goal
          _DropdownTile(
            isDark: isDark,
            icon: Icons.timer_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Daily Mindfulness Goal',
            value: _sessionGoal,
            items: _sessionGoals,
            onChanged: (v) => setState(() => _sessionGoal = v!),
          ),

          const SizedBox(height: 8),
          _SectionLabel('EXPERIENCE'),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.volume_up_outlined,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Sound Effects',
            subtitle: 'Play sounds during activities',
            value: _soundEffects,
            onChanged: (v) => setState(() => _soundEffects = v),
          ),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.vibration,
            iconColor: const Color(0xFFF59E0B),
            title: 'Haptic Feedback',
            subtitle: 'Vibration on interactions',
            value: _hapticFeedback,
            onChanged: (v) => setState(() => _hapticFeedback = v),
          ),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.play_circle_outline,
            iconColor: const Color(0xFF06B6D4),
            title: 'Auto-play Meditations',
            subtitle: 'Start next session automatically',
            value: _autoPlay,
            onChanged: (v) => setState(() => _autoPlay = v),
          ),

          const SizedBox(height: 8),
          _SectionLabel('STORAGE'),

          _ActionTile(
            isDark: isDark,
            icon: Icons.cleaning_services_outlined,
            iconColor: const Color(0xFFFF8C42),
            title: 'Clear Cache',
            subtitle: 'Free up local storage space',
            trailing: const Text('12 MB',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            onTap: () => _showConfirm(
              context,
              title: 'Clear Cache',
              message:
                  'This will clear temporary files. Your data will not be affected.',
              onConfirm: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('✅ Cache cleared!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFF6C63FF))),
            ),
          ),

          const SizedBox(height: 8),
          _SectionLabel('ABOUT'),

          _ActionTile(
            isDark: isDark,
            icon: Icons.info_outline,
            iconColor: const Color(0xFF6C63FF),
            title: 'App Version',
            subtitle: 'MindFull Path v1.0.0',
            trailing: const Text('v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            onTap: () {},
          ),

          _ActionTile(
            isDark: isDark,
            icon: Icons.description_outlined,
            iconColor: Colors.grey,
            title: 'Terms of Service',
            subtitle: 'Read our terms',
            onTap: () {},
          ),

          _ActionTile(
            isDark: isDark,
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.grey,
            title: 'Privacy Policy',
            subtitle: 'How we handle your data',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('✅ Settings saved!'),
                backgroundColor: Color(0xFF6C63FF),
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showConfirm(BuildContext context,
      {required String title,
      required String message,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm',
                style: TextStyle(color: Color(0xFF6C63FF))),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
                color: Colors.grey)),
      );
}

class _DropdownTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title, value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownTile(
      {required this.isDark,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600))),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            style: TextStyle(
                color: const Color(0xFF6C63FF),
                fontWeight: FontWeight.w600,
                fontSize: 14),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ]),
      );
}

class _ToggleTile extends StatelessWidget {
  final bool isDark, value;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final ValueChanged<bool> onChanged;

  const _ToggleTile(
      {required this.isDark,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ])),
          Switch(
              value: value,
              activeColor: const Color(0xFF6C63FF),
              onChanged: onChanged),
        ]),
      );
}

class _ActionTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ActionTile(
      {required this.isDark,
      required this.icon,
      required this.iconColor,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.trailing});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2035) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 22)),
            const SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ])),
            trailing ??
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: Colors.grey.shade400),
          ]),
        ),
      );
}
