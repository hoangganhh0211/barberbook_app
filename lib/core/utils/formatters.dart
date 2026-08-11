import 'package:intl/intl.dart';

abstract class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'đ',
    decimalDigits: 0,
  );

  /// Vi du: 100000 -> "100.000 đ".
  static String currency(num amount) => _currencyFormat.format(amount);

  /// Vi du: 30 -> "30 phút", 90 -> "1 giờ 30 phút", 60 -> "1 giờ".
  static String duration(int minutes) {
    if (minutes < 60) return '$minutes phút';
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return remainingMinutes == 0 ? '$hours giờ' : '$hours giờ $remainingMinutes phút';
  }

  static final DateFormat _dateTimeFormat = DateFormat('EEEE, dd/MM/yyyy - HH:mm', 'vi_VN');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');

  /// Vi du: "Thứ Ba, 12/08/2026 - 14:30".
  static String dateTime(DateTime value) => _dateTimeFormat.format(value);

  static String time(DateTime value) => _timeFormat.format(value);

  static String date(DateTime value) => _dateFormat.format(value);

  /// Vi du: "Vừa xong", "5 phút trước", "3 giờ trước", "2 ngày trước".
  static String relativeTime(DateTime value) {
    final Duration diff = DateTime.now().difference(value);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return date(value);
  }
}