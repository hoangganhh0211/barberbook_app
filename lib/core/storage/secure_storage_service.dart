import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Noi duy nhat trong toan app duoc phep doc/ghi token.
///
/// KHONG bao gio luu access_token/refresh_token bang `shared_preferences`
/// (plain text, khong ma hoa) - bat buoc dung `flutter_secure_storage`
/// (Keychain tren iOS, EncryptedSharedPreferences tren Android) theo dung
/// yeu cau bao mat cua tai lieu (muc 1.5.3 - Quan ly phien & Token).
class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  static const _keyAccessToken = 'access_token';
  static const _keyRefreshToken = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  /// Goi khi logout hoac khi refresh token that bai (session thuc su het han).
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
    ]);
  }
}
