import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/service/auth_service.dart';
abstract class AuthRepository {
  Future<Failure?> login({required String phone, required String password});
  Future<Failure?> register({
    required String phone,
    required String fullName,
    required String password,
  });
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
  Future<Failure?> register({
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
    }
  }
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