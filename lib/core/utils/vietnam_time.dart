
abstract final class VietnamTime {
  static const Duration utcOffset = Duration(hours: 7);


  static DateTime nowUtc() => DateTime.now().toUtc();


  static DateTime nowWall() => toWall(DateTime.now().toUtc());


  static DateTime toWall(DateTime instant) {
    final DateTime shifted = instant.toUtc().add(utcOffset);
    return DateTime.utc(
      shifted.year,
      shifted.month,
      shifted.day,
      shifted.hour,
      shifted.minute,
      shifted.second,
      shifted.millisecond,
      shifted.microsecond,
    );
  }

  static DateTime wallToUtc(DateTime wallTime) => DateTime.utc(
        wallTime.year,
        wallTime.month,
        wallTime.day,
        wallTime.hour,
        wallTime.minute,
        wallTime.second,
        wallTime.millisecond,
        wallTime.microsecond,
      ).subtract(utcOffset);


  static DateTime todayCalendarDate() {
    final DateTime wall = nowWall();
    return DateTime(wall.year, wall.month, wall.day);
  }


  static DateTime calendarDateAfter(DateTime date, int days) =>
      DateTime(date.year, date.month, date.day + days);


  static DateTime startOfDayUtc(DateTime vietnamDate) => DateTime.utc(
        vietnamDate.year,
        vietnamDate.month,
        vietnamDate.day,
      ).subtract(utcOffset);


  static DateTime startOfMonthUtc(int year, int month) =>
      DateTime.utc(year, month).subtract(utcOffset);
}
