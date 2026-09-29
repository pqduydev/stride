import 'package:stride/features/reminder/reminder_time_calculator.dart';
import 'package:stride/model/reminder_settings.dart';
import 'package:stride/services/notification_service.dart';

class ReminderScheduler {
  final NotificationService _notifications;

  ReminderScheduler(this._notifications);

  // id 101..107: mỗi NGÀY TẬP trong tuần một thông báo lặp lại
  static const _weeklyBaseId = 100;

  Future<bool> ensurePermission() => _notifications.requestPermission();

  Future<void> apply(ReminderSettings settings) async {
    // 1. Luôn huỷ hết lịch cũ trước → không sót thông báo của ngày vừa bỏ chọn
    for (var day = DateTime.monday; day <= DateTime.sunday; day++) {
      await _notifications.cancel(_weeklyBaseId + day);
    }
    if (!settings.enabled) return;

    // 2. Đặt lại từng ngày đã chọn
    final trainingTime = '${_two(settings.hour)}:${_two(settings.minute)}';
    for (final day in settings.weekdays) {
      final at = ReminderTimeCalculator.shiftBack(
        weekday: day,
        hour: settings.hour,
        minute: settings.minute,
        minutesBefore: settings.minutesBefore,
      );
      await _notifications.scheduleWeekly(
        id: _weeklyBaseId + day, // id theo ngày TẬP, không theo ngày NHẮC
        weekday: at.weekday,
        hour: at.hour,
        minute: at.minute,
        title: 'Chuẩn bị cho buổi tập',
        body: settings.minutesBefore == 0
            ? 'Đến giờ tập rồi ($trainingTime)!'
            : 'Buổi tập bắt đầu lúc $trainingTime, còn ${settings.minutesBefore} phút.',
        data: const {'type': 'workout_reminder'},
      );

      // await _notifications.scheduleWeekly(
      //   id: 200 + day, // ID đúng giờ
      //   weekday: day,
      //   hour: settings.hour,
      //   minute: settings.minute,
      //   title: 'Đến giờ tập rồi!',
      //   body: 'Bắt đầu buổi tập hôm nay thôi nào!',
      //   data: const {'type': 'workout_reminder'},
      // );
    }
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
