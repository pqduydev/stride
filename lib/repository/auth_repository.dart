import 'package:dio/dio.dart';
import 'package:stride/model/user_model.dart';
import 'package:stride/services/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient.instance;

  Future<UserModel> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await _dio.post(
        'v1/auth/register/',
        data: {
          'username': username,
          'email': email.trim().toLowerCase(),
          'password': password,
          'password_confirm': passwordConfirm,
          'first_name': firstName,
          'last_name': lastName,
        },
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorData = e.response?.data;

      if (errorData is Map) {
        // Ném nguyên bản Map lỗi từ Django để tầng Cubit xử lý
        throw errorData;
      }
      throw {'detail': 'Đã có lỗi xảy ra, vui lòng thử lại'};
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      final response = await _dio.post(
        'v1/auth/login/',
        data: {'username': normalizedEmail, 'password': password},
      );

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      final errorData = e.response?.data;
      String errorMessage = 'Tài khoản hoặc mật khẩu không chính xác';

      if (errorData is Map) {
        if (errorData.containsKey('detail')) {
          errorMessage = errorData['detail'];
        } else if (errorData.containsKey('non_field_errors')) {
          errorMessage = errorData['non_field_errors'][0];
        }
      }
      throw Exception(errorMessage);
    }
  }
}
