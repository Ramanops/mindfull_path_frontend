import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatefulWidget {
  const PrivacySecurityScreen({super.key});
  @override
  State<PrivacySecurityScreen> createState() => _PrivacySecurityScreenState();
}

class _PrivacySecurityScreenState extends State<PrivacySecurityScreen> {
  bool _biometric = false;
  bool _dataCollection = true;
  bool _crashReports = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _SectionLabel('SECURITY'),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.fingerprint,
            iconColor: const Color(0xFF6C63FF),
            title: 'Biometric Lock',
            subtitle: 'Use fingerprint or face to unlock',
            value: _biometric,
            onChanged: (v) => setState(() => _biometric = v),
          ),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.verified_user_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Two-Factor Authentication',
            subtitle: 'Extra layer of account security',
            value: _twoFactor,
            onChanged: (v) => setState(() => _twoFactor = v),
          ),

          _ActionTile(
            isDark: isDark,
            icon: Icons.lock_reset_outlined,
            iconColor: const Color(0xFFF59E0B),
            title: 'Change Password',
            subtitle: 'Update your account password',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Go to Personal Info to change password'),
                  behavior: SnackBarBehavior.floating)),
          ),

          const SizedBox(height: 8),
          _SectionLabel('DATA & PRIVACY'),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.analytics_outlined,
            iconColor: const Color(0xFF06B6D4),
            title: 'Usage Analytics',
            subtitle: 'Help improve the app anonymously',
            value: _dataCollection,
            onChanged: (v) => setState(() => _dataCollection = v),
          ),

          _ToggleTile(
            isDark: isDark,
            icon: Icons.bug_report_outlined,
            iconColor: const Color(0xFF8B5CF6),
            title: 'Crash Reports',
            subtitle: 'Send crash data to developers',
            value: _crashReports,
            onChanged: (v) => setState(() => _crashReports = v),
          ),

          const SizedBox(height: 8),
          _SectionLabel('ACCOUNT DATA'),

          _ActionTile(
            isDark: isDark,
            icon: Icons.download_outlined,
            iconColor: const Color(0xFF10B981),
            title: 'Export My Data',
            subtitle: 'Download all your journal & mood data',
            onTap: () => _showConfirmDialog(
              context,
              title: 'Export Data',
              message: 'We will prepare your data export and notify you when ready.',
              confirmLabel: 'Request Export',
              confirmColor: const Color(0xFF10B981),
            ),
          ),

          _ActionTile(
            isDark: isDark,
            icon: Icons.delete_outline,
            iconColor: Colors.red,
            title: 'Delete Account',
            subtitle: 'Permanently remove your account',
            onTap: () => _showConfirmDialog(
              context,
              title: 'Delete Account',
              message: 'This will permanently delete all your data. This cannot be undone.',
              confirmLabel: 'Delete',
              confirmColor: Colors.red,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.privacy_tip_outlined, color: Color(0xFF6C63FF), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your data is encrypted and never sold to third parties.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF6C63FF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, {
    required String title, required String message,
    required String confirmLabel, required Color confirmColor,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(confirmLabel, style: TextStyle(color: confirmColor)),
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
        child: Text(text, style: const TextStyle(
            fontSize: 11, letterSpacing: 1.5,
            fontWeight: FontWeight.w700, color: Colors.grey)),
      );
}

class _ToggleTile extends StatelessWidget {
  final bool isDark, value;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({required this.isDark, required this.icon,
    required this.iconColor, required this.title, required this.subtitle,
    required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )),
          Switch(value: value, activeColor: const Color(0xFF6C63FF), onChanged: onChanged),
        ]),
      );
}

class _ActionTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title, subtitle;
  final VoidCallback onTap;

  const _ActionTile({required this.isDark, required this.icon,
    required this.iconColor, required this.title, required this.subtitle,
    required this.onTap});

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
            Container(width: 44, height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            )),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
          ]),
        ),
      );
}