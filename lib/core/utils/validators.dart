/// Cac ham validate dung chung cho `TextFormField.validator`. Tra ve `null`
/// neu hop le, tra ve chuoi loi (hien duoi input) neu khong hop le - dung
/// dung "hop dong" cua `FormFieldValidator<String>`.
///
/// KHONG viet lai regex/logic validate rieng le o tung Screen - moi rule
/// nghiep vu (do dai, dinh dang) chi dinh nghia DUY NHAT o day.
abstract class Validators {
  static final RegExp _vnPhoneRegExp = RegExp(r'^(0|\+84)(3|5|7|8|9)\d{8}$');
  static final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');

  static String? phone(String? value) {
    final String input = (value ?? '').trim().replaceAll(' ', '');
    if (input.isEmpty) return 'Vui lòng nhập số điện thoại';
    if (!_vnPhoneRegExp.hasMatch(input)) return 'Số điện thoại không hợp lệ';
    return null;
  }

  static String? password(String? value) {
    final String input = value ?? '';
    if (input.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (input.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
    return null;
  }

  static String? email(String? value) {
    final String input = (value ?? '').trim();
    if (input.isEmpty) return 'Vui lòng nhập email';
    if (!_emailRegExp.hasMatch(input)) return 'Email không hợp lệ';
    return null;
  }

  /// Dung cho form "Dat lai mat khau" (Sprint 1 - phan Quen mat khau) -
  /// so sanh 2 truong password trung khop.
  static String? Function(String?) confirmPassword(String originalPassword) {
    return (String? value) {
      if (value != originalPassword) return 'Mật khẩu xác nhận không khớp';
      return null;
    };
  }
}
