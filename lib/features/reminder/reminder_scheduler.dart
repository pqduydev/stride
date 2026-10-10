import 'package:easy_localization/easy_localization.dart';
import 'package:stride/core/utils/reminder_time_calculator.dart';
import 'package:stride/model/reminder_settings.dart';
import 'package:stride/services/notification_service.dart';

class ReminderScheduler {
  final NotificationService _notifications;

  ReminderScheduler(this._notifications);

  static const _weeklyBaseId = 100;

  Future<void> ensurePermission() => _notifications.requestPermission();

  Future<void> apply(ReminderSettings settings) async {
    for (var day = DateTime.monday; day <= DateTime.sunday; day++) {
      await _notifications.cancel(_weeklyBaseId + day);
      await _notifications.cancel(200 + day);
    }
    if (!settings.enabled) return;

    final trainingTime = '${_two(settings.hour)}:${_two(settings.minute)}';
    for (final day in settings.weekdays) {
      final at = ReminderTimeCalculator.shiftBack(
        weekday: day,
        hour: settings.hour,
        minute: settings.minute,
        minutesBefore: settings.minutesBefore,
      );
      await _notifications.scheduleWeekly(
        id: _weeklyBaseId + day,
        weekday: at.weekday,
        hour: at.hour,
        minute: at.minute,
        title: 'reminder_scheduler.title_prepare'.tr(),
        body: settings.minutesBefore == 0
            ? 'reminder_scheduler.body_prepare_exact'.tr(args: [trainingTime])
            : 'reminder_scheduler.body_prepare_before'.tr(
                args: [trainingTime, settings.minutesBefore.toString()],
              ),
        data: const {'type': 'workout_reminder'},
      );

      await _notifications.scheduleWeekly(
        id: 200 + day,
        weekday: day,
        hour: settings.hour,
        minute: settings.minute,
        title: 'reminder_scheduler.title_time'.tr(),
        body: 'reminder_scheduler.body_time'.tr(),
        data: const {'type': 'workout_reminder'},
      );
    }
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
