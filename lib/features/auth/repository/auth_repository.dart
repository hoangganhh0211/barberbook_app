import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/service/auth_service.dart';

/// Interface truu tuong - moi Provider/Controller PHAI phu thuoc vao day,
/// KHONG phu thuoc truc tiep [AuthRepositoryImpl] (Dependency Inversion) -
/// de de thay the bang Fake khi viet unit test cho [AuthController].
abstract class AuthRepository {
  /// Tra ve `null` neu thanh cong, [Failure] neu that bai. KHONG can tra ve
  /// [UserSession] o day - [AuthController] se tu cap nhat state khi
  /// `onAuthStateChange` phat su kien dang nhap (xem [AuthService]).
  Future<Failure?> login({required String phone, required String password});

  Future<Failure?> requestRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  });

  Future<Failure?> resendRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  });

  Future<Failure?> verifyRegisterOtp({required String phone, required String otpCode});

  /// Doc ho ten + role tu bang `profiles` - dung moi khi `onAuthStateChange`
  /// bao co session (dang nhap moi, khoi phuc phien, hoac token vua duoc
  /// tu dong refresh).
  Future<Result<UserSession>> fetchUserSession(String userId);

  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<Failure?> login({required String phone, required String password}) {
    return _runVoidAction(
      () => _authService.signInWithPassword(phone: phone, password: password),
    );
  }

  @override
  Future<Failure?> requestRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  }) {
    return _runVoidAction(
      () => _authService.signUpWithPhonePassword(
        phone: phone,
        password: password,
        fullName: fullName,
      ),
    );
  }

  @override
  Future<Failure?> resendRegisterOtp({
    required String phone,
    required String fullName,
    required String password,
  }) {
    return _runVoidAction(
      () => _authService.resendSignUpOtp(phone: phone, password: password, fullName: fullName),
    );
  }

  @override
  Future<Failure?> verifyRegisterOtp({required String phone, required String otpCode}) {
    return _runVoidAction(
      () => _authService.verifySignUpOtp(phone: phone, otpCode: otpCode),
    );
  }

  @override
  Future<Result<UserSession>> fetchUserSession(String userId) async {
    try {
      final Map<String, dynamic> row = await _authService.fetchProfile(userId);
      return Success(UserSession.fromProfileRow(row));
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (_) {
      // Best-effort - Supabase SDK van tu xoa session luu local du goi API
      // that bai (vd: mat mang dung luc bam Dang xuat).
    }
  }

  /// Helper dung chung cho moi action CHI can biet thanh cong/that bai
  /// (khong can du lieu tra ve) - tranh lap 4 khoi try/catch giong het nhau.
  Future<Failure?> _runVoidAction(Future<void> Function() action) async {
    try {
      await action();
      return null;
    } on AuthException catch (e) {
      return mapSupabaseAuthError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}