import 'package:easy_localization/easy_localization.dart';

class TimeUtils {
  static String formatDuration(DateTime start, DateTime end) {
    // Chỉ lấy ngày, tháng, năm
    final startDateOnly = DateTime(start.year, start.month, start.day);
    final endDateOnly = DateTime(end.year, end.month, end.day);

    if (endDateOnly.isBefore(startDateOnly)) {
      return 'time_utils.zero_days'.tr();
    }

    final totalDays = endDateOnly.difference(startDateOnly).inDays;

    // 1. Dưới 1 tuần (< 7 ngày)
    if (totalDays < 7) {
      if (totalDays == 0) return 'time_utils.zero_days'.tr();
      if (totalDays == 1) return 'time_utils.one_day'.tr();
      return 'time_utils.days'.tr(args: [totalDays.toString()]);
    }

    // 2. Từ 1 tuần đến dưới 1 tháng (7 -> 29 ngày)
    if (totalDays < 30) {
      final weeks = totalDays ~/ 7;
      final remDays = totalDays % 7;
      if (remDays == 0) {
        return weeks == 1
            ? 'time_utils.one_week'.tr()
            : 'time_utils.weeks'.tr(args: [weeks.toString()]);
      }
      return 'time_utils.weeks_days'.tr(
        args: [weeks.toString(), remDays.toString()],
      );
    }

    // 3. Từ 1 tháng đến dưới 1 năm (30 -> 364 ngày)
    if (totalDays < 365) {
      final months = totalDays ~/ 30;
      final remAfterMonths = totalDays % 30;
      final weeks = remAfterMonths ~/ 7;

      if (weeks == 0) {
        return months == 1
            ? 'time_utils.one_month'.tr()
            : 'time_utils.months'.tr(args: [months.toString()]);
      }
      return 'time_utils.months_weeks'.tr(
        args: [months.toString(), weeks.toString()],
      );
    }

    // 4. Từ 1 năm trở lên (>= 365 ngày)
    final years = totalDays ~/ 365;
    final remAfterYears = totalDays % 365;
    final months = remAfterYears ~/ 30;

    if (months == 0) {
      return years == 1
          ? 'time_utils.one_year'.tr()
          : 'time_utils.years'.tr(args: [years.toString()]);
    }
    return 'time_utils.years_months'.tr(
      args: [years.toString(), months.toString()],
    );
  }
}
