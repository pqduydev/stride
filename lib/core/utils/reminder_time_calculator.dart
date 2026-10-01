import 'package:stride/model/reminder_settings.dart';

typedef WeeklyTime = ({int weekday, int hour, int minute});

class ReminderTimeCalculator {
  static const _minutesPerDay = 24 * 60;
  static const _minutesPerWeek = 7 * _minutesPerDay;

  /// Lùi (thứ, giờ, phút) về trước [minutesBefore] phút.
  /// VD: Thứ Hai 00:10, nhắc trước 15 phút → Chủ nhật 23:55.
  static WeeklyTime shiftBack({
    required int weekday,
    required int hour,
    required int minute,
    required int minutesBefore,
  }) {
    // Đổi ra "số phút tính từ 00:00 thứ Hai"
    var total =
        (weekday - 1) * _minutesPerDay + hour * 60 + minute - minutesBefore;
    // Trong Dart, % với số chia dương luôn ra số không âm: -15 % 10080 = 10065
    total %= _minutesPerWeek;

    return (
      weekday: total ~/ _minutesPerDay + 1,
      hour: (total % _minutesPerDay) ~/ 60,
      minute: total % 60,
    );
  }

  /// Lần nhắc gần nhất sau [now]. null nếu đang tắt hoặc chưa chọn ngày.
  /// Dùng cho dòng "Lần tiếp theo: Thứ Hai, 14/09 lúc 17:45" (Figma màn 12).
  static DateTime? nextReminder(ReminderSettings settings, DateTime now) {
    if (!settings.enabled || settings.weekdays.isEmpty) return null;

    DateTime? best;
    for (final day in settings.weekdays) {
      final at = shiftBack(
        weekday: day,
        hour: settings.hour,
        minute: settings.minute,
        minutesBefore: settings.minutesBefore,
      );
      var date = DateTime(now.year, now.month, now.day, at.hour, at.minute);
      while (date.weekday != at.weekday || !date.isAfter(now)) {
        date = DateTime(
          date.year,
          date.month,
          date.day + 1,
          at.hour,
          at.minute,
        );
      }
      if (best == null || date.isBefore(best)) best = date;
    }
    return best;
  }
}
