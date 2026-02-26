import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/gradient_button.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleAuth(bool isLogin) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _email.text.trim();
    final password = _password.text.trim();

    try {
      if (isLogin) {
        await ref.read(authProvider.notifier).login(email, password);
      } else {
        await ref.read(authProvider.notifier).register(email, password);
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentication failed. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(authModeProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.padding),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(AppConstants.cardRadius),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                )
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.flash_on,
                      size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text("Mindful Path",
                      style: AppTextStyles.headline),
                  const SizedBox(height: 8),
                  Text("Find peace within",
                      style: AppTextStyles.caption),
                  const SizedBox(height: 24),

                  /// 🔥 LOGIN / REGISTER TOGGLE
                  ToggleButtons(
                    borderRadius: BorderRadius.circular(30),
                    isSelected: [isLogin, !isLogin],
                    onPressed: (i) =>
                    ref.read(authModeProvider.notifier).state =
                        i == 0,
                    children: const [
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 24),
                        child: Text("Login"),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 24),
                        child: Text("Register"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _email,
                    validator: Validators.email,
                    decoration:
                    const InputDecoration(labelText: "Email"),
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    validator: Validators.password,
                    decoration:
                    const InputDecoration(labelText: "Password"),
                  ),

                  const SizedBox(height: 24),

                  /// 🔥 AUTH BUTTON
                  GradientButton(
                    text: _isLoading
                        ? "Please wait..."
                        : isLogin
                        ? "SIGN IN"
                        : "REGISTER",
                    onTap: _isLoading
                        ? null
                        : () => _handleAuth(isLogin),
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot password?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}