import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://10.7.231.253:3000/api",
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'access_token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }

  // ✅ Add this
  Future<dynamic> post(
      String path,
      Map<String, dynamic> data,
      ) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }

  // Optional: GET
  Future<dynamic> get(String path) async {
    final response = await dio.get(path);
    return response.data;
  }
}