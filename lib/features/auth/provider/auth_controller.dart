import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/otp_request_result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_providers.dart';

/// Trang thai xac thuc cua toan app - [AppRouter] se doc state nay de
/// quyet dinh redirect (xem `route_guard.dart`).
sealed class AuthState {
  const AuthState();
}

/// Chua xac dinh - dang trong qua trinh kiem tra token co san hay khong
/// (goi API `/auth/me` khi app vua mo). Hien Splash Screen o trang thai nay.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);
  final UserSession session;
}

/// Notifier trung tam quan ly phien dang nhap - "nguon su that" duy nhat
/// ve trang thai xac thuc cua toan app.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthUnknown();
  }

  /// Khoi phuc phien dang nhap khi mo lai app: neu co access_token da luu,
  /// goi `/auth/me` de xac nhan token con hop le (va lay UserSession moi
  /// nhat). Neu token het han, [AuthInterceptor] se tu dong thu refresh
  /// truoc khi request that bai hoan toan - o day chi can xu ly ket qua
  /// cuoi cung tra ve tu Repository.
  Future<void> _restoreSession() async {
    final String? accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      state = const AuthUnauthenticated();
      return;
    }

    final Result<UserSession> result = await ref.read(authRepositoryProvider).getCurrentUser();
    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data);
      case ResultFailure():
        // Token khong con hop le (ke ca truong hop AuthInterceptor da thu
        // refresh nhung refresh_token cung het han) - buoc dang xuat that su.
        await ref.read(secureStorageServiceProvider).clearTokens();
        state = const AuthUnauthenticated();
    }
  }

  /// Goi tu [LoginScreen] (US-AUTH-001 - dang nhap SDT/Password).
  ///
  /// Tra ve `null` neu thanh cong (UI khong can tu dieu huong - xem
  /// `route_guard.dart` se tu redirect khi state doi sang [AuthAuthenticated]).
  /// Tra ve [Failure] neu that bai de UI tu hien thi thong bao loi tuong ung.
  Future<Failure?> loginWithPhonePassword({
    required String phone,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).login(
          phone: phone,
          password: password,
        );

    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data.user);
        return null;
      case ResultFailure(:final failure):
        return failure;
    }
  }

  /// Buoc 1 dang ky (US-AUTH-001): gui SDT + ho ten de nhan OTP.
  ///
  /// Tra ve nguyen [Result] (khong rut gon thanh `Failure?` nhu
  /// [loginWithPhonePassword]) vi [RegisterScreen] can lay du lieu thanh
  /// cong (`otpRequestId`, `expiresInSeconds`) de chuyen tiep sang [OtpScreen].
  Future<Result<OtpRequestResult>> requestRegisterOtp({
    required String phone,
    required String fullName,
  }) {
    return ref.read(authRepositoryProvider).requestRegisterOtp(
          phone: phone,
          fullName: fullName,
        );
  }

  /// Buoc 2 dang ky: xac thuc OTP + tao mat khau.
  ///
  /// Thanh cong = tu dong dang nhap (giong [loginWithPhonePassword]) -
  /// `route_guard.dart` se tu dieu huong vao dung Shell theo role, [OtpScreen]
  /// khong can tu dieu huong.
  Future<Failure?> completeRegistration({
    required String otpRequestId,
    required String otpCode,
    required String password,
  }) async {
    final result = await ref.read(authRepositoryProvider).verifyOtpAndRegister(
          otpRequestId: otpRequestId,
          otpCode: otpCode,
          password: password,
        );

    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data.user);
        return null;
      case ResultFailure(:final failure):
        return failure;
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthUnauthenticated();
  }

  /// CHI DUNG CHO DEV/QA khi chua co backend that de test Role-based
  /// routing (xem cach dung trong `LoginScreen` - duoc an sau `kDebugMode`).
  /// KHONG duoc goi ham nay o bat ky luong nghiep vu that nao.
  void debugSignInAs(UserRole role) {
    state = AuthAuthenticated(
      UserSession(userId: 'debug-user-id', fullName: 'Người dùng Demo', role: role),
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
