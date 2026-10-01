import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stride/services/api_exception.dart';

class DeviceTokenRepository {
  // Tạo một instance của Dio để gọi API
  final Dio _dio;

  DeviceTokenRepository({required this._dio});

  // Gửi FCM Token lên Backend để lưu vào DB của User
  Future<void> registerDeviceToken({required String fcmToken}) async {
    try {
      await _dio.post(
        'v1/notifications/device-token/',
        data: {
          'token': fcmToken,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    } catch (e) {
      throw ApiException(message: 'Lỗi không xác định khi đăng ký Token: $e');
    }
  }

  // Hủy FCM Token trên Backend khi Người dùng Đăng xuất (Logout)
  Future<void> unregisterDeviceToken({required String fcmToken}) async {
    try {
      await _dio.delete(
        'v1/notifications/device-token/',
        data: {'token': fcmToken},
      );
    } on DioException catch (e) {
      debugPrint(
        'Lỗi hủy FCM Token trên Backend: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw ApiException(message: 'Lỗi không xác định khi hủy Token: $e');
    }
  }
}
