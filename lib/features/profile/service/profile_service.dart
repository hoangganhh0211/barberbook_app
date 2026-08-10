import 'package:supabase_flutter/supabase_flutter.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho thao tac SUA ho so
/// (khac voi doc ho so - thuoc ve `AuthService.fetchProfile`, van giu o
/// feature `auth` vi gan voi luong dang nhap/khoi phuc phien).
class ProfileService {
  ProfileService(this._client);

  final SupabaseClient _client;

  /// Sprint 4 CHI ho tro sua ho ten - CHUA co avatar upload (can Supabase
  /// Storage, se lam khi co nhu cau thuc te ro rang hon).
  Future<void> updateFullName(String fullName) async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Chưa đăng nhập - không thể cập nhật hồ sơ.');
    }

    await _client.from('profiles').update({'full_name': fullName}).eq('id', userId);
  }
}