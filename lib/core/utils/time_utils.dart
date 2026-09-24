class TimeUtils {
  static String formatDuration(DateTime start, DateTime end) {
    // Chỉ lấy ngày, tháng, năm
    final startDateOnly = DateTime(start.year, start.month, start.day);
    final endDateOnly = DateTime(end.year, end.month, end.day);

    if (endDateOnly.isBefore(startDateOnly)) return '0 ngày';

    final totalDays = endDateOnly.difference(startDateOnly).inDays;

    // 1. Dưới 1 tuần (< 7 ngày)
    if (totalDays < 7) {
      return '$totalDays ngày';
    }

    // 2. Từ 1 tuần đến dưới 1 tháng (7 -> 29 ngày)
    if (totalDays < 30) {
      final weeks = totalDays ~/ 7;
      final remDays = totalDays % 7;
      if (remDays == 0) return '$weeks tuần';
      return '$weeks tuần $remDays ngày';
    }

    // 3. Từ 1 tháng đến dưới 1 năm (30 -> 364 ngày)
    if (totalDays < 365) {
      final months = totalDays ~/ 30;
      final remAfterMonths = totalDays % 30;
      final weeks = remAfterMonths ~/ 7;

      if (weeks == 0) return '$months tháng';
      return '$months tháng $weeks tuần';
    }

    // 4. Từ 1 năm trở lên (>= 365 ngày)
    final years = totalDays ~/ 365;
    final remAfterYears = totalDays % 365;
    final months = remAfterYears ~/ 30;

    if (months == 0) return '$years năm';
    return '$years năm $months tháng';
  }
}
