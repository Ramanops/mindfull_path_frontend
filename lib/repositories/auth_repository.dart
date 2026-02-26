import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/network/api_client.dart';

class AuthRepository {
  final ApiClient api;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this.api);

  /// 🔐 Login
  Future<String> login(String email, String password) async {
    try {
      final response = await api.dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      if (data == null || data['accessToken'] == null) {
        throw Exception('Invalid login response');
      }

      final accessToken = data['accessToken'] as String;

      await _storage.write(
        key: 'access_token',
        value: accessToken,
      );

      return accessToken;
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? 'Login failed. Please try again.';
        throw Exception(message);
      } else {
        throw Exception('Network error. Please check your connection.');
      }
    } catch (_) {
      throw Exception('Unexpected error occurred.');
    }
  }

  /// 🆕 Register
  Future<String> register(String email, String password) async {
    try {
      final response = await api.dio.post(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      if (data == null || data['accessToken'] == null) {
        throw Exception('Invalid registration response');
      }

      final accessToken = data['accessToken'] as String;

      await _storage.write(
        key: 'access_token',
        value: accessToken,
      );

      return accessToken;
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? 'Registration failed.';
        throw Exception(message);
      } else {
        throw Exception('Network error. Please check connection.');
      }
    } catch (_) {
      throw Exception('Unexpected error occurred.');
    }
  }

  /// 🚪 Logout
  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  /// 📦 Get saved token
  Future<String?> getSavedToken() async {
    return await _storage.read(key: 'access_token');
  }
}