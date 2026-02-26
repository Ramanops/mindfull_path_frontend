import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/auth_repository.dart';
import '../core/network/api_client.dart';

/// 🔹 Auth Mode Toggle
final authModeProvider = StateProvider<bool>((ref) => true);

/// 🔹 API Client
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// 🔹 Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AuthRepository(apiClient);
});

/// 🔹 Auth State
final authProvider =
StateNotifierProvider<AuthNotifier, String?>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AuthNotifier(repository);
});

class AuthNotifier extends StateNotifier<String?> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(null) {
    _loadToken();
  }

  /// 🔄 Auto-load saved token
  Future<void> _loadToken() async {
    final savedToken = await repository.getSavedToken();
    if (savedToken != null) {
      state = savedToken;
    }
  }

  /// 🔐 Login
  Future<void> login(String email, String password) async {
    final token = await repository.login(email, password);
    state = token;
  }

  /// 🆕 Register
  Future<void> register(String email, String password) async {
    final token = await repository.register(email, password);
    state = token;
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await repository.logout();
    state = null;
  }
}