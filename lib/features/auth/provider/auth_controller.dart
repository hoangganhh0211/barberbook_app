import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_providers.dart';

/// Trang thai xac thuc cua toan app - [AppRouter] se doc state nay de
/// quyet dinh redirect (xem `route_guard.dart`).
///
/// LUU Y: ten trung voi `supa.AuthState` cua Supabase SDK (dai dien 1 SU
/// KIEN thay doi auth: {event, session}) - 2 khai niem khac nhau hoan toan.
/// File nay import Supabase voi alias `supa` de tranh nham lan.
sealed class AuthState {
  const AuthState();
}

/// Chua xac dinh - dang cho su kien dau tien tu `onAuthStateChange`
/// (Supabase luon phat 1 su kien `initialSession` ngay khi subscribe, cho
/// biet co phien cu duoc luu hay khong). Hien Splash Screen o trang thai nay.
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
  StreamSubscription<supa.AuthState>? _authSubscription;

  @override
  AuthState build() {
    // Subscribe 1 LAN duy nhat khi Controller duoc khoi tao. Supabase se
    // tu phat su kien `initialSession` ngay lap tuc (co the session=null
    // neu chua tung dang nhap, hoac session cu neu con hop le) - dung de
    // khoi phuc phien khi mo lai app, THAY THE hoan toan cho viec goi API
    // `/auth/me` thu cong nhu kien truc REST truoc day.
    //
    // Khai bao kieu TUONG MINH o day (khong de Dart tu suy luan) vi
    // `supa.AuthState` (su kien cua Supabase) rat de bi nham voi `AuthState`
    // (state cua app, khai bao ngay phia tren) - neu 1 trong 2 cho bi go
    // nham (vd: IDE tu "organize imports" lam mat prefix `supa.`), loi se
    // hien ra CHINH XAC o dong nay thay vi bao chung chung "type dynamic".
    final Stream<supa.AuthState> authStream = ref.read(authServiceProvider).onAuthStateChange;
    _authSubscription = authStream.listen(_handleAuthStateChange);
    ref.onDispose(() => _authSubscription?.cancel());

    return const AuthUnknown();
  }

  Future<void> _handleAuthStateChange(supa.AuthState data) async {
    final supa.Session? session = data.session;
    if (session == null) {
      state = const AuthUnauthenticated();
      return;
    }

    final Result<UserSession> result = await ref.read(authRepositoryProvider).fetchUserSession(
          session.user.id,
        );

    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data);
      case ResultFailure():
        // Co session hop le nhung khong doc duoc `profiles` (hiem gap, vd:
        // du lieu bi xoa thu cong) - dang xuat de tranh ket ket o trang
        // thai "nua vay nua khong" (co session nhung khong co UserSession).
        await ref.read(authRepositoryProvider).logout();
        state = const AuthUnauthenticated();
    }
  }

  /// Goi tu [LoginScreen] (US-AUTH-001 - dang nhap SDT/Password).
  ///
  /// Tra ve `null` neu thanh cong (UI khong can tu dieu huong/tu cap nhat
  /// state - [_handleAuthStateChange] se tu lam khi Supabase phat su kien
  /// dang nhap). Tra ve [Failure] neu that bai de UI tu hien thi loi.
  Future<Failure?> loginWithPhonePassword({
    required String phone,
    required String password,
  }) {
    return ref.read(authRepositoryProvider).login(phone: phone, password: password);
  }

  /// Buoc 1 dang ky: tao user (chua active) + Supabase tu gui OTP qua SMS.
  Future<Failure?> requestRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  }) {
    return ref.read(authRepositoryProvider).requestRegisterOtp(
          phone: phone,
          fullName: fullName,
          password: password,
        );
  }

  Future<Failure?> resendRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  }) {
    return ref.read(authRepositoryProvider).resendRegisterOtp(
          phone: phone,
          fullName: fullName,
          password: password,
        );
  }

  /// Buoc 2 dang ky: xac thuc OTP. Thanh cong = tu dong dang nhap (Supabase
  /// tra ve session, `onAuthStateChange` tu cap nhat state) - khong can tu
  /// dieu huong o UI.
  Future<Failure?> verifyRegisterOtp({
    required String phone,
    required String otpCode,
  }) {
    return ref.read(authRepositoryProvider).verifyRegisterOtp(phone: phone, otpCode: otpCode);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
    // Khong can tu set state = AuthUnauthenticated - Supabase se tu phat
    // su kien `signedOut` qua `onAuthStateChange`, [_handleAuthStateChange]
    // se tu xu ly.
  }

  /// CHI DUNG CHO DEV/QA de test Role-based routing khi chua co du lieu
  /// that trong Supabase (xem cach dung trong `LoginScreen`, an sau
  /// `kDebugMode`). KHONG duoc goi ham nay o bat ky luong nghiep vu that nao.
  void debugSignInAs(UserRole role) {
    state = AuthAuthenticated(
      UserSession(userId: 'debug-user-id', fullName: 'Người dùng Demo', role: role),
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);