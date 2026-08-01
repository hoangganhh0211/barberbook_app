import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';

/// Dung trong MOI Repository (o khoi `catch`) de convert loi tu Supabase
/// SDK sang [Failure] co san - dung vai tro tuong duong `extractAppException`
/// da dung voi Dio truoc day, nhung cho Supabase.
///
/// Vi du dung trong Repository:
/// ```dart
/// try {
///   final res = await supabase.auth.signInWithPassword(...);
///   return Success(res);
/// } on AuthException catch (e) {
///   return ResultFailure(mapSupabaseAuthError(e));
/// } on PostgrestException catch (e) {
///   return ResultFailure(mapSupabasePostgrestError(e));
/// } catch (_) {
///   return const ResultFailure(NetworkFailure('Khong co ket noi mang.'));
/// }
/// ```
Failure mapSupabaseAuthError(AuthException error) {
  // Supabase tra ve `statusCode` dang String? (vd: "400", "422") - so sanh
  // qua so nguyen de tranh sai lech kieu du lieu.
  final int? statusCode = int.tryParse(error.statusCode ?? '');

  return switch (statusCode) {
    401 => AuthFailure(_translateAuthMessage(error)),
    422 => ServerFailure(_translateAuthMessage(error)),
    429 => const ServerFailure('Bạn thao tác quá nhanh, vui lòng thử lại sau ít phút.'),
    _ => ServerFailure(_translateAuthMessage(error)),
  };
}

Failure mapSupabasePostgrestError(PostgrestException error) {
  // Ma loi Postgres pho bien: "PGRST301"/"42501" ~ vi pham RLS (khong du
  // quyen truy cap dong du lieu do) - map sang PermissionFailure de UI
  // hien thi dung thong bao thay vi loi chung chung.
  if (error.code == '42501' || error.code == 'PGRST301') {
    return const PermissionFailure('Bạn không có quyền thực hiện thao tác này.');
  }
  return ServerFailure(error.message, errorCode: error.code);
}

/// Dich vai message loi pho bien cua Supabase Auth sang tieng Viet - Supabase
/// KHONG ho tro sẵn i18n cho message loi, nen phai tu map thu cong o day.
/// Message nao chua co trong danh sach se hien nguyen van tu Supabase.
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