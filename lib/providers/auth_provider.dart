import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../core/network/api_client.dart';

final authModeProvider = StateProvider<bool>((ref) => true);

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(apiClientProvider));
});

// ✅ Now stores email (not JWT token) for display
final authProvider = StateNotifierProvider<AuthNotifier, String?>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<String?> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(null) {
    _loadSavedEmail();
  }

  /// 🔄 Load saved email on app start
  Future<void> _loadSavedEmail() async {
    final savedEmail = await repository.getSavedEmail();
    if (savedEmail != null) {
      state = savedEmail; // ✅ shows email, not token
    }
  }

  /// 🔐 Login — state set to email
  Future<void> login(String email, String password) async {
    await repository.login(email, password);
    state = email; // ✅ store email in state
  }

  /// 🆕 Register — state set to email
  Future<void> register(String email, String password) async {
    await repository.register(email, password);
    state = email; // ✅ store email in state
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await repository.logout();
    state = null;
  }
}
