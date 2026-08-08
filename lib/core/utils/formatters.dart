import 'package:intl/intl.dart';

/// Cac ham format dung chung - dung `intl` (da co san tu Sprint 0) thay vi
/// tu viet regex chen dau phay thu cong.
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

  /// Vi du: "Thứ Ba, 12/08/2026 - 14:30". CAN GOI
  /// `initializeDateFormatting('vi_VN')` truoc (da lam san trong
  /// `main.dart`), neu khong se nem `LocaleDataException` khi goi ham nay.
  static String dateTime(DateTime value) => _dateTimeFormat.format(value);

  static String time(DateTime value) => _timeFormat.format(value);

  static String date(DateTime value) => _dateFormat.format(value);
}