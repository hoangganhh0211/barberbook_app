import 'package:shared_preferences/shared_preferences.dart';

/// Luu cac gia tri KHONG nhay cam: co da xem onboarding chua, ngon ngu dang
/// chon, theme mode... Moi thu lien quan Auth/PII phai dung
/// [SecureStorageService], khong dung o day.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  static const _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const _keyLocaleCode = 'locale_code';

  bool get hasSeenOnboarding => _prefs.getBool(_keyHasSeenOnboarding) ?? false;

  Future<void> setHasSeenOnboarding(bool value) =>
      _prefs.setBool(_keyHasSeenOnboarding, value);

  String? get localeCode => _prefs.getString(_keyLocaleCode);

  Future<void> setLocaleCode(String code) =>
      _prefs.setString(_keyLocaleCode, code);
}
