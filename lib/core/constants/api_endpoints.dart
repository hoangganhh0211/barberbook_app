/// Tap trung toan bo path cua API (relative theo [AppConfig.apiBaseUrl]).
///
/// Quy uoc: nhom theo feature bang comment, bo sung dan qua tung Sprint.
/// KHONG duoc phep hardcode string path truc tiep trong ApiService.
abstract class ApiEndpoints {
  // ----- Auth (US-AUTH-001) - se bo sung o Sprint 1 -----
  static const String login = '/auth/login';
  static const String registerRequestOtp = '/auth/register/otp';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh-token';
  static const String socialLogin = '/auth/social-login';
  static const String logout = '/auth/logout';

  /// Lay thong tin user hien tai tu access_token - dung de khoi phuc phien
  /// dang nhap khi mo lai app (xem `AuthController._restoreSession()`).
  static const String me = '/auth/me';
}
