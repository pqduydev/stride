import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  );

  static void setupInterceptors(Function() onUnauthenticated) {
    instance.interceptors.add(
      QueuedInterceptorsWrapper(
        // Queued... dừng request lỗi và khóa các request khác
        // Tự động thêm Access Token vào mọi Request đi
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },

        // Bắt lỗi trả về từ Server
        onError: (DioException error, handler) async {
          // Chỉ xử lý khi gặp lỗi 401
          if (error.response?.statusCode == 401) {
            final prefs = await SharedPreferences.getInstance();
            final refreshToken = prefs.getString('refresh_token');

            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                // Tạo 1 Dio riêng biệt để gọi Refresh API tránh lặp vô tận khi
                // Dio hiện có gọi Refresh API lại nhận lỗi về onError
                final refreshDio = Dio(
                  BaseOptions(baseUrl: instance.options.baseUrl),
                );

                final response = await refreshDio.post(
                  'v1/auth/refresh/',
                  data: {'refresh': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['access'];

                  // Lưu token mới
                  await prefs.setString('access_token', newAccessToken);

                  // Cập nhật Header cho request bị lỗi ban đầu
                  error.requestOptions.headers['Authorization'] =
                      'Bearer $newAccessToken';

                  // Thử lại request ban đầu với Token mới
                  final clonedRequest = await instance.fetch(
                    error.requestOptions,
                  );
                  return handler.resolve(
                    clonedRequest,
                  ); // Trả kết quả thành công về cho App
                }
              } catch (_) {
                // Gọi Refresh Token thất bại -> Bị rớt xuống bước dọn dẹp dưới
              }
            }

            // Xử lý khi Refresh thất bại hoặc không có Refresh Token
            await prefs.clear(); // Xóa sạch dữ liệu cục bộ
            onUnauthenticated(); // Đẩy về màn hình chính
          }

          return handler.next(error);
        },
      ),
    );
  }
}
