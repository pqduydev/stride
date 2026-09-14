import 'package:dio/dio.dart';

class DioClient {
  static final Dio instance = Dio(
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
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}
