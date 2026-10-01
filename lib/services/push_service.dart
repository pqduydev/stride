import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:stride/firebase_options.dart';
import 'package:stride/repository/device_token_repository.dart';
import 'package:stride/services/notification_service.dart';

/// Chạy trong một isolate riêng khi app ở nền hoặc đã tắt.
/// BẮT BUỘC: hàm top-level (nằm ngoài class) + @pragma. Thiếu @pragma,
/// bản release sẽ bị trình biên dịch lược bỏ vì tưởng không ai gọi.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Tin có khối "notification" → Android tự hiện, không cần làm gì.
  // Tin chỉ có "data" → nếu muốn hiện thông báo thì xử lý ở đây.
}

class PushService {
  final DeviceTokenRepository _repository;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  StreamSubscription<String>? _refreshSub;

  PushService(this._repository);

  Future<void> init() async {
    // App đang mở: Android KHÔNG tự hiện → tự hiện bằng local notification
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      NotificationService.instance.showNow(
        id: (message.messageId ?? '').hashCode & 0x7FFFFFFF,
        title: notification.title ?? 'Stride',
        body: notification.body ?? '',
        data: message.data,
      );
    });

    // Bấm push khi app đang chạy nền
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      NotificationService.instance.emitTap(message.data);
    });

    // Bấm push khi app đã tắt hẳn
    /* getInitialMessage trả lời cho câu hỏiapp được mở bằng 
     thông báo khi app tắt (trả về RemoteMassage) hay mở bình thường */
    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      NotificationService.instance.setLaunchData(initial.data);
    }
  }

  /// Gọi khi đã đăng nhập (đăng nhập xong, hoặc mở app lúc đã đăng nhập sẵn).
  Future<void> syncToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _register(token);
        if (kDebugMode) debugPrint('FCM token: $token');
      }
      _refreshSub ??= _messaging.onTokenRefresh.listen(_register);
    } catch (_) {
      // Lỗi đăng ký token không được làm hỏng luồng đăng nhập
    }
  }

  /// Gọi TRƯỚC khi xoá access token lúc đăng xuất (DELETE cần access token).
  Future<void> unregisterToken() async {
    try {
      await _refreshSub?.cancel();
      _refreshSub = null;
      final token = await _messaging.getToken();
      if (token != null) {
        await _repository.unregisterDeviceToken(fcmToken: token);
      }
      await _messaging.deleteToken(); // lần đăng nhập sau sẽ nhận token mới
    } catch (_) {
      // Không chặn đăng xuất vì lỗi mạng
    }
  }

  /// Gọi khi bị đăng xuất cưỡng bức (refresh token hết hạn). Lúc này không còn
  /// access token để gọi DELETE, nên huỷ token ngay tại Firebase: push gửi tới
  /// token cũ sẽ thất bại, người dùng sau trên máy này không nhận nhầm.
  Future<void> deleteLocalToken() async {
    try {
      await _refreshSub?.cancel();
      _refreshSub = null;
      await _messaging.deleteToken();
    } catch (_) {}
  }

  Future<void> _register(String token) async {
    try {
      await _repository.registerDeviceToken(fcmToken: token);
    } catch (_) {}
  }
}
