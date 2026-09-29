import 'package:go_router/go_router.dart';

/// Mở màn phù hợp theo dữ liệu của thông báo (local hoặc FCM).
void openFromNotification(GoRouter router, Map<String, dynamic> data) {
  switch (data['type']) {
    case 'workout_reminder':
      router.push('/reminder_settings');
    case 'schedule_reminder':
      // Khi có màn chi tiết buổi tập: router.push('/appointment/${data['schedule_id']}');
      router.push('/appointment');
  }
}
