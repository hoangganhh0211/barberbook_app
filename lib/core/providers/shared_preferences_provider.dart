import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPreferences.getInstance] la async nen KHONG the khoi tao truc
/// tiep trong `build()` cua 1 Provider thuong. Thay vao do, `main.dart` se
/// `await` truoc, roi dung `overrides: [sharedPreferencesProvider.overrideWithValue(...)]`
/// khi tao `ProviderScope` - dam bao moi noi trong app doc duoc gia tri
/// that ngay tu frame dau tien, khong co truong hop "chua san sang".
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider phai duoc override trong main.dart truoc khi dung.',
  );
});
