import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';


Failure mapSupabaseAuthError(AuthException error) {
  final int? statusCode = int.tryParse(error.statusCode ?? '');

  return switch (statusCode) {
    401 => AuthFailure(_translateAuthMessage(error)),
    422 => ServerFailure(_translateAuthMessage(error)),
    429 => const ServerFailure('Bạn thao tác quá nhanh, vui lòng thử lại sau ít phút.'),
    _ => ServerFailure(_translateAuthMessage(error)),
  };
}

Failure mapSupabasePostgrestError(PostgrestException error) {
  if (error.code == '42501' || error.code == 'PGRST301') {
    return const PermissionFailure('Bạn không có quyền thực hiện thao tác này.');
  }
  return ServerFailure(error.message, errorCode: error.code);
}

String _translateAuthMessage(AuthException error) {
  final String raw = error.message.toLowerCase();

  if (raw.contains('invalid login credentials')) {
    return 'Số điện thoại hoặc mật khẩu không đúng.';
  }
  if (raw.contains('user already registered') || raw.contains('already exists')) {
    return 'Số điện thoại này đã được đăng ký.';
  }
  if (raw.contains('token has expired') || raw.contains('otp expired')) {
    return 'Mã OTP đã hết hạn, vui lòng gửi lại mã.';
  }
  if (raw.contains('invalid otp') || raw.contains('invalid token')) {
    return 'Mã OTP không đúng.';
  }
  if (raw.contains('password') && raw.contains('least')) {
    return 'Mật khẩu chưa đủ mạnh (tối thiểu 6 ký tự).';
  }

  return error.message;
}