import 'package:supabase_flutter/supabase_flutter.dart';

/// Tang DUY NHAT trong feature Auth duoc phep import `supabase_flutter`.
///
/// GIAI PHAP KY THUAT: Supabase bat buoc phai co 1 SMS provider (Twilio...)
/// moi cho bat "Phone provider" - de tranh phu thuoc/chi phi ben thu 3
/// khong can thiet (app khong dung OTP), ta dung EMAIL provider (mien phi,
/// luon san co) nhung "gia lap" SDT thanh 1 email noi bo duy nhat cho moi
/// SDT. Nguoi dung KHONG BAO GIO thay khai niem email - Repository/Controller/
/// Screen phia tren van chi lam viec voi `phone` nhu binh thuong, khong sua
/// gi ca (xem [_phoneToSyntheticEmail]).
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  /// Stream phat ra moi khi trang thai dang nhap thay doi (dang nhap, dang
  /// xuat, token duoc tu dong refresh...). Day la "nguon su that" chinh de
  /// [AuthController] lang nghe.
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  Future<AuthResponse> signInWithPassword({
    required String phone,
    required String password,
  }) {
    return _auth.signInWithPassword(
      email: _phoneToSyntheticEmail(phone),
      password: password,
    );
  }

  Future<AuthResponse> signUpWithPhonePassword({
    required String phone,
    required String password,
    required String fullName,
  }) {
    final String normalizedPhone = _normalizePhone(phone);
    return _auth.signUp(
      email: _phoneToSyntheticEmail(phone),
      password: password,
      data: {'full_name': fullName, 'phone': normalizedPhone},
    );
  }

  /// Doc thong tin mo rong (ho ten, role, SDT that) tu bang `profiles` -
  /// Supabase Auth mac dinh KHONG co san full_name/role, va `phone` trong
  /// `auth.users` luc nay dang de trong (vi dung Email provider) - SDT that
  /// nam trong `profiles.phone`, duoc luu tu `data: {'phone': ...}` o tren.
  Future<Map<String, dynamic>> fetchProfile(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }

  Future<void> signOut() => _auth.signOut();

  /// Chuyen SDT thanh 1 email noi bo DUY NHAT va ON DINH - cung 1 SDT nhap
  /// kieu nao ("0912xxxxxx" hay "+84912xxxxxx") deu ra CUNG 1 email (nho
  /// [_normalizePhone]), de dang nhap luon khop voi luc dang ky.
  String _phoneToSyntheticEmail(String phone) {
    return '${_normalizePhone(phone)}@barber.com';
  }

  /// Chuan hoa SDT ve dang chi gom chu so, luon bat dau bang "84" (bo dau
  /// "+" va doi tien to "0" thanh "84") - tranh truong hop 1 SDT thuc te
  /// nhung go 2 kieu khac nhau bi tinh la 2 tai khoan khac nhau.
  String _normalizePhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.startsWith('+84')) {
      digits = '84${digits.substring(3)}';
    } else if (digits.startsWith('0')) {
      digits = '84${digits.substring(1)}';
    }
    return digits;
  }
}
