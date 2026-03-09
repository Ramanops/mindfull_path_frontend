import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';

class AuthRepository {
  final ApiClient api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this.api);

  /// 🔐 Login
  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await api.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final data = response.data;
      if (data == null || data['accessToken'] == null) throw Exception('Invalid login response');
      final accessToken = data['accessToken'] as String;
      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'user_email', value: email); // ✅ save email too
      return {'token': accessToken, 'email': email};
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Login failed. Please try again.';
      throw Exception(message);
    } catch (_) {
      throw Exception('Unexpected error occurred.');
    }
  }

  /// 🆕 Register
  Future<Map<String, String>> register(String email, String password) async {
    try {
      final response = await api.dio.post('/auth/register', data: {
        'email': email,
        'password': password,
      });
      final data = response.data;
      if (data == null || data['accessToken'] == null) throw Exception('Invalid registration response');
      final accessToken = data['accessToken'] as String;
      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'user_email', value: email); // ✅ save email too
      return {'token': accessToken, 'email': email};
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed.';
      throw Exception(message);
    } catch (_) {
      throw Exception('Unexpected error occurred.');
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'user_email'); // ✅ clear email too
  }

  /// 📦 Get saved token
  Future<String?> getSavedToken() async => await _storage.read(key: 'access_token');

  /// 📧 Get saved email  ← NEW
  Future<String?> getSavedEmail() async => await _storage.read(key: 'user_email');
}