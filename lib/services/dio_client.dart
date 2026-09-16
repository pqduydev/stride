import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final Dio instance =
      Dio(
          BaseOptions(
            baseUrl: 'https://gympath-server-django.onrender.com/api/',
            connectTimeout: const Duration(
              seconds: 15,
            ), // Thời gian chờ kết nối tối đa
            receiveTimeout: const Duration(
              seconds: 15,
            ), // Thời gian chờ nhận dữ liệu tối đa
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        )
        ..interceptors.addAll([
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('access_token');
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
              return handler.next(options);
            },
          ),
          LogInterceptor(requestBody: true, responseBody: true),
        ]);
}
