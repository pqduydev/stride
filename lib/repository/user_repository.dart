import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stride/model/user_model.dart';
import 'package:stride/services/api_exception.dart';

class UserRepository {
  final Dio _dio;

  UserRepository({required this._dio});

  Future<UserModel> updateProfile(Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.patch('/v1/auth/me/', data: updateData);

      final updatedUser = UserModel.fromJson(response.data);

      // Đồng bộ ngay dữ liệu mới vào SharedPreferences ở local
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(updatedUser.toJson()));

      return updatedUser;
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }
}
