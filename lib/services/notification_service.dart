import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Không đổi id kênh sau khi đã phát hành
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'workout_reminder',
    'Nhắc giờ tập',
    description: 'Nhắc trước buổi tập đã lên lịch',
    importance: Importance.high,
  );

  // Phát dữ liệu mỗi khi người dùng bấm thông báo lúc app đang chạy
  final StreamController<Map<String, dynamic>> _tapController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get onTap => _tapController.stream;

  // Dữ liệu của thông báo đã mở app từ trạng thái tắt hẳn (chỉ đọc 1 lần)
  Map<String, dynamic>? _launchData;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> init() async {
    // 1. Múi giờ: bắt buộc trước khi dùng zonedSchedule
    tz.initializeTimeZones();
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezone.identifier));
    } catch (_) {
      // Một số máy trả tên múi giờ lạ → dùng giờ Việt Nam
      tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
    }

    // 2. Khởi tạo plugin
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        final data = decodePayload(response.payload);
        if (data != null) _tapController.add(data);
      },
    );

    // 3. Tạo kênh (gọi nhiều lần không sao)
    await _android?.createNotificationChannel(channel);

    // 4. App có được mở bằng cách bấm thông báo không?
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      _launchData = decodePayload(launch!.notificationResponse?.payload);
    }
  }

  /// Lấy dữ liệu thông báo đã mở app, và xoá luôn để không xử lý 2 lần.
  Map<String, dynamic>? consumeLaunchData() {
    final data = _launchData;
    _launchData = null;
    return data;
  }

  static Map<String, dynamic>? decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Android 13+: hiện hộp thoại xin quyền. Android cũ: trả về thông báo có đang bật không.
  Future<bool> requestPermission() async {
    final granted = await _android?.requestNotificationsPermission();
    return granted ?? false;
  }

  NotificationDetails get _details => NotificationDetails(
    android: AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  /// Có quyền hẹn giờ chính xác thì dùng, không thì hẹn gần đúng.
  Future<AndroidScheduleMode> _scheduleMode() async {
    final canExact = await _android?.canScheduleExactNotifications() ?? false;
    return canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  /// Hiện ngay lập tức.
  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    return _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details,
      payload: data == null ? null : jsonEncode(data),
    );
  }

  /// Lặp lại mỗi tuần vào [weekday] lúc [hour]:[minute].
  Future<void> scheduleWeekly({
    required int id,
    required int weekday, // DateTime.monday (1) ... DateTime.sunday (7)
    required int hour,
    required int minute,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstance(weekday, hour, minute),
      notificationDetails: _details,
      androidScheduleMode: await _scheduleMode(),
      // Chỉ so khớp "thứ + giờ + phút" → tuần nào cũng nổ
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: data == null ? null : jsonEncode(data),
    );
  }

  /// Nổ đúng một lần tại [at]. Thời điểm đã qua thì bỏ qua.
  Future<void> scheduleOnce({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final when = tz.TZDateTime.from(at, tz.local);
    if (!when.isAfter(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: await _scheduleMode(),
      payload: data == null ? null : jsonEncode(data),
    );
  }

  /// Lần gần nhất (sau hiện tại) rơi vào [weekday] lúc [hour]:[minute].
  tz.TZDateTime _nextInstance(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var date = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (date.weekday != weekday || !date.isAfter(now)) {
      date = tz.TZDateTime(
        tz.local,
        date.year,
        date.month,
        date.day + 1,
        hour,
        minute,
      );
    }
    return date;
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  Future<List<PendingNotificationRequest>> pending() =>
      _plugin.pendingNotificationRequests();
}
