import 'package:flutter/services.dart';

class MediaPickerException implements Exception {
  final String message;

  MediaPickerException(this.message);

  @override
  String toString() => message;
}

/// Chạy một lệnh của image_picker, đổi lỗi kỹ thuật thành câu tiếng Việt.
/// Giống cách ApiException bọc DioException.
Future<T> guardPicker<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on PlatformException catch (e) {
    throw MediaPickerException(switch (e.code) {
      'camera_access_denied' =>
        'Stride chưa được phép dùng camera. Hãy bật trong Cài đặt của máy.',
      'photo_access_denied' => 'Stride chưa được phép truy cập ảnh.',
      'no_available_camera' => 'Không tìm thấy camera trên thiết bị này.',
      _ => e.message ?? 'Không mở được camera hoặc thư viện.',
    });
  }
}
