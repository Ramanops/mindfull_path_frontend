import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio dio = Dio();
  final FlutterSecureStorage storage =
  const FlutterSecureStorage();

  ApiClient() {
    dio.options.baseUrl = "http://10.0.2.2:3000/api";
    dio.options.headers = {
      'Content-Type': 'application/json',
    };

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token =
          await storage.read(key: 'access_token');

          if (token != null) {
            options.headers['Authorization'] =
            'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }
}