import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/providers/shared_preferences_provider.dart';
import 'package:barberbook_app/core/storage/local_storage_service.dart';
import 'package:barberbook_app/core/storage/secure_storage_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

/// [SupabaseClient] dung chung toan app - moi `XxxService` (Auth, Booking,
/// Shop...) se `ref.watch(supabaseClientProvider)` thay vi tu goi
/// `Supabase.instance.client` rai rac o nhieu noi.
///
/// Session/token refresh gio DA duoc chinh SDK Supabase tu quan ly ben
/// trong (khong con can `AuthInterceptor`/`tokenRefresher` thu cong nhu
/// khi dung Dio truoc day) - day chinh la ly do file nay ngan di rat nhieu
/// so voi ban cu.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});