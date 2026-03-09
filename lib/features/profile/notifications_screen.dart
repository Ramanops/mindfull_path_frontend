import 'package:flutter/material.dart';
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _dailyReminder = true;
  bool _moodCheckin = true;
  bool _streakAlert = true;
  bool _journalPrompt = false;
  bool _weeklyReport = true;
  bool _meditationReminder = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context, initialTime: _reminderTime);
    if (picked != null) setState(() => _reminderTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _SectionLabel('DAILY REMINDERS'),
          _NotifTile(
            isDark: isDark,
            icon: Icons.wb_sunny_outlined,
            iconColor: const Color(0xFFF59E0B),
            title: 'Daily Reminder',
            subtitle: 'Morning nudge to check in',
            value: _dailyReminder,
            onChanged: (v) => setState(() => _dailyReminder = v),
          ),

          // Reminder time picker (shows only when daily reminder is on)
          if (_dailyReminder)
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E2035) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time,
                          color: Color(0xFF6C63FF)),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Reminder Time',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          Text('Tap to change',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      _reminderTime.format(context),
                      style: const TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

          _NotifTile(
            isDark: isDark,
            icon: Icons.mood,
            iconColor: const Color(0xFF10B981),
            title: 'Mood Check-in',
            subtitle: 'Remind to log your mood',
            value: _moodCheckin,
            onChanged: (v) => setState(() => _moodCheckin = v),
          ),

          _NotifTile(
            isDark: isDark,
            icon: Icons.local_fire_department_outlined,
            iconColor: const Color(0xFFFF8C42),
            title: 'Streak Alert',
            subtitle: "Don't break your streak!",
            value: _streakAlert,
            onChanged: (v) => setState(() => _streakAlert = v),
          ),

          const SizedBox(height: 8),
          _SectionLabel('CONTENT'),

          _NotifTile(
            isDark: isDark,
            icon: Icons.menu_book_outlined,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Journal Prompts',
            subtitle: 'Daily writing inspiration',
            value: _journalPrompt,
            onChanged: (v) => setState(() => _journalPrompt = v),
          ),

          _NotifTile(
            isDark: isDark,
            icon: Icons.self_improvement,
            iconColor: const Color(0xFF06B6D4),
            title: 'Meditation Reminder',
            subtitle: 'Time to find your calm',
            value: _meditationReminder,
            onChanged: (v) => setState(() => _meditationReminder = v),
          ),

          _NotifTile(
            isDark: isDark,
            icon: Icons.bar_chart_outlined,
            iconColor: const Color(0xFF6C63FF),
            title: 'Weekly Report',
            subtitle: 'Your weekly wellness summary',
            value: _weeklyReport,
            onChanged: (v) => setState(() => _weeklyReport = v),
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('✅ Notification preferences saved!'),
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
            child: const Text('Save Preferences',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                fontSize: 11, letterSpacing: 1.5,
                fontWeight: FontWeight.w700, color: Colors.grey)),
      );
}

class _NotifTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifTile({
    required this.isDark, required this.icon, required this.iconColor,
    required this.title, required this.subtitle,
    required this.value, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
                  Text(title, style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(subtitle, style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Switch(
              value: value,
              activeColor: const Color(0xFF6C63FF),
              onChanged: onChanged,
            ),
          ],
        ),
      );
}