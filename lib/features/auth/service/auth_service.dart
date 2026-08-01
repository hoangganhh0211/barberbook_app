import 'package:supabase_flutter/supabase_flutter.dart';

/// Tang DUY NHAT trong feature Auth duoc phep import `supabase_flutter`.
///
/// So voi `AuthApiService` (dung Dio) truoc day, class nay KHONG tu quan ly
/// token/refresh - Supabase SDK da lam viec do ben trong. Repository/Provider
/// phia tren van giu nguyen "hinh dang" (Result/Failure), chi thay doi cach
/// class nay hien thuc ben trong.
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  /// Stream phat ra moi khi trang thai dang nhap thay doi (dang nhap, dang
  /// xuat, token duoc tu dong refresh...). Day la "nguon su that" chinh de
  /// [AuthController] lang nghe - THAY THE hoan toan cho viec tu goi API
  /// `/auth/me` nhu kien truc REST truoc day.
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  Future<AuthResponse> signInWithPassword({
    required String phone,
    required String password,
  }) {
    return _auth.signInWithPassword(phone: phone, password: password);
  }

  /// Buoc 1 dang ky (US-AUTH-001): tao user (o trang thai CHUA active) +
  /// Supabase tu dong gui OTP qua SMS. Chua co session ngay - phai xac
  /// thuc OTP o buoc sau ([verifySignUpOtp]) moi thuc su dang nhap duoc.
  ///
  /// `data: {'full_name': fullName}` duoc luu vao `raw_user_meta_data` cua
  /// Supabase - trigger `handle_new_user()` trong `supabase/schema.sql` se
  /// doc gia tri nay de tao dong tuong ung trong bang `profiles`.
  Future<AuthResponse> signUpWithPhonePassword({
    required String phone,
    required String password,
    required String fullName,
  }) {
    return _auth.signUp(
      phone: phone,
      password: password,
      data: {'full_name': fullName},
    );
  }

  /// Buoc 2 dang ky: xac thuc ma OTP vua nhan qua SMS. Thanh cong se tra ve
  /// session (tu dong dang nhap luon, khong bat nguoi dung dang nhap lai).
  Future<AuthResponse> verifySignUpOtp({
    required String phone,
    required String otpCode,
  }) {
    return _auth.verifyOTP(type: OtpType.sms, phone: phone, token: otpCode);
  }

  /// Gui lai OTP cho SDT dang cho xac thuc (dung LAI signUp - Supabase tu
  /// nhan dien day la yeu cau gui lai neu user chua duoc xac thuc).
  Future<void> resendSignUpOtp({
    required String phone,
    required String password,
    required String fullName,
  }) {
    return signUpWithPhonePassword(phone: phone, password: password, fullName: fullName);
  }

  /// Doc thong tin mo rong (ho ten, role) tu bang `profiles` - Supabase Auth
  /// mac dinh KHONG co san 2 field nay (xem doc comment trong `UserSession`).
  Future<Map<String, dynamic>> fetchProfile(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }

  Future<void> signOut() => _auth.signOut();
}