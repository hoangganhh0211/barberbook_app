import 'package:intl/intl.dart';

import 'package:barberbook_app/core/utils/vietnam_time.dart';

abstract class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );


  static String currency(num amount) => _currencyFormat.format(amount);


  static String duration(int minutes) {
    if (minutes < 60) return '$minutes phút';
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return remainingMinutes == 0 ? '$hours giờ' : '$hours giờ $remainingMinutes phút';
  }

  static final DateFormat _dateTimeFormat = DateFormat('EEEE, dd/MM/yyyy - HH:mm', 'vi_VN');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');


  static String dateTime(DateTime value) => _dateTimeFormat.format(value);


  static String dateTimeVietnam(DateTime instant) =>
      _dateTimeFormat.format(VietnamTime.toWall(instant));

  static String timeVietnam(DateTime instant) =>
      _timeFormat.format(VietnamTime.toWall(instant));

  static String dateVietnam(DateTime instant) =>
      _dateFormat.format(VietnamTime.toWall(instant));

  static String time(DateTime value) => _timeFormat.format(value);

  static String date(DateTime value) => _dateFormat.format(value);

  static String relativeTime(DateTime value) {
    final Duration diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return dateVietnam(value);
  }
}