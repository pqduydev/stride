import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stride/model/user_model.dart';
import 'package:stride/services/api_exception.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({required this._dio});

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        'v1/auth/login/',
        data: {'username': username, 'password': password},
      );

      final user = UserModel.fromJson(response.data);
      final prefs = await SharedPreferences.getInstance();

      // Lưu Tokens & User Profile Data
      if (user.accessToken != null) {
        await prefs.setString('access_token', user.accessToken!);
      }
      if (user.refreshToken != null) {
        await prefs.setString('refresh_token', user.refreshToken!);
      }
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      return user;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      // Thống nhất ném ApiException
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  // Lấy dữ liệu đã được lưu lại dưới SharedPreferences sau khi đăng nhập thành công
  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');

    if (userDataString != null && userDataString.isNotEmpty) {
      try {
        Map<String, dynamic> userMap = jsonDecode(userDataString);
        return UserModel.fromJson(userMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Lấy dữ liệu người dùng hiện tại
  Future<UserModel> getUser() async {
    try {
      final reponse = await _dio.get('/v1/auth/me/', data: {});

      final user = UserModel.fromJson(reponse.data);
      final prefs = await SharedPreferences.getInstance();

      // Cập nhật User Profile Data
      await prefs.setString('user_data', jsonEncode(user.toJson()));

      return user;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

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
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _dio.post('v1/auth/logout/', data: {'refresh': refreshToken});
      }
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Đã có lỗi xảy ra, vui lòng thử lại');
    } finally {
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_data');
    }
  }
}
