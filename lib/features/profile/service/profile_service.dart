import 'package:supabase_flutter/supabase_flutter.dart';
class ProfileService {
  ProfileService(this._client);

  final SupabaseClient _client;
  Future<void> updateFullName(String fullName) async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw StateError('Chưa đăng nhập - không thể cập nhật hồ sơ.');
    }

    await _client.from('profiles').update({'full_name': fullName}).eq('id', userId);
  }
}