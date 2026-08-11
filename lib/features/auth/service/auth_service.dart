import 'package:supabase_flutter/supabase_flutter.dart';
class AuthService {
  AuthService(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;
  Stream<AuthState> get onAuthStateChange => _auth.onAuthStateChange;

  Session? get currentSession => _auth.currentSession;

  Future<AuthResponse> signInWithPassword({
    required String phone,
    required String password,
  }) {
    return _auth.signInWithPassword(
      email: _phoneToSyntheticEmail(phone),
      password: password,
    );
  }

  Future<AuthResponse> signUpWithPhonePassword({
    required String phone,
    required String password,
    required String fullName,
  }) {
    final String normalizedPhone = _normalizePhone(phone);
    return _auth.signUp(
      email: _phoneToSyntheticEmail(phone),
      password: password,
      data: {'full_name': fullName, 'phone': normalizedPhone},
    );
  }
  Future<Map<String, dynamic>> fetchProfile(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }

  Future<void> signOut() => _auth.signOut();
  String _phoneToSyntheticEmail(String phone) {
    return '${_normalizePhone(phone)}@barber.com';
  }
  String _normalizePhone(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (digits.startsWith('+84')) {
      digits = '84${digits.substring(3)}';
    } else if (digits.startsWith('0')) {
      digits = '84${digits.substring(1)}';
    }
    return digits;
  }
}
