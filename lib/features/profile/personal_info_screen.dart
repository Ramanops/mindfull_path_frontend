import 'package:flutter/material.dart';
class PersonalInfoScreen extends StatefulWidget {
  final String email;
  const PersonalInfoScreen({super.key, required this.email});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final username = widget.email.contains('@')
        ? widget.email.split('@').first : widget.email;
    _nameController = TextEditingController(text: username);
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Profile updated successfully!'),
        backgroundColor: Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color(0xFF6C63FF).withOpacity(0.15),
                    child: Text(
                      _nameController.text.isNotEmpty
                          ? _nameController.text[0].toUpperCase() : 'U',
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold,
                          color: Color(0xFF6C63FF)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6C63FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            _SectionTitle('PROFILE DETAILS'),
            const SizedBox(height: 12),

            _InfoCard(
              isDark: isDark,
              child: Column(
                children: [
                  _InputField(
                    controller: _nameController,
                    label: 'Display Name',
                    icon: Icons.person_outline,
                  ),
                  const Divider(height: 1),
                  _InputField(
                    controller: _emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _SectionTitle('CHANGE PASSWORD'),
            const SizedBox(height: 12),

            _InfoCard(
              isDark: isDark,
              child: Column(
                children: [
                  _InputField(
                    controller: _currentPassController,
                    label: 'Current Password',
                    icon: Icons.lock_outline,
                    obscure: _obscureCurrent,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureCurrent
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                  ),
                  const Divider(height: 1),
                  _InputField(
                    controller: _newPassController,
                    label: 'New Password',
                    icon: Icons.lock_reset_outlined,
                    obscure: _obscureNew,
                    suffixIcon: IconButton(
                      icon: Icon(_obscureNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) => Text(title,
      style: const TextStyle(
          fontSize: 11, letterSpacing: 1.5,
          fontWeight: FontWeight.w700, color: Colors.grey));
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _InfoCard({required this.child, required this.isDark});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2035) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                blurRadius: 8)
          ],
        ),
        child: child,
      );
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller, required this.label, required this.icon,
    this.obscure = false, this.keyboardType, this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: suffixIcon,
            border: InputBorder.none,
          ),
        ),
      );
}