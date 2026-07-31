import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/config/app_config.dart';
import 'package:barberbook_app/core/constants/api_endpoints.dart';
import 'package:barberbook_app/core/network/dio_client.dart';
import 'package:barberbook_app/core/providers/shared_preferences_provider.dart';
import 'package:barberbook_app/core/storage/local_storage_service.dart';
import 'package:barberbook_app/core/storage/secure_storage_service.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalStorageService(prefs);
});

/// [Dio] instance dung chung toan app - moi `XxxApiService` se
/// `ref.watch(dioClientProvider).dio` thay vi tu tao `Dio()` rieng.
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);

  return DioClient(
    secureStorage: secureStorage,
    tokenRefresher: (refreshToken) => _refreshAccessToken(secureStorage, refreshToken),
    onSessionExpired: () {
      ref.read(authControllerProvider.notifier).signOut();
    },
  );
});

/// Goi truc tiep API refresh-token bang 1 [Dio] "sach" (khong gan
/// AuthInterceptor). CO CHU Y khong dung `authRepositoryProvider` o day de
/// tranh circular dependency:
/// `authRepositoryProvider -> dioClientProvider -> tokenRefresher -> authRepositoryProvider`.
///
/// Day la ngoai le DUY NHAT noi `core/` "biet" ve 1 API endpoint cu the
/// (thay vi de feature Auth quyet dinh) - bat nguon tu ban chat "ga va
/// trung" von co cua co che refresh-token: Dio can token de khoi tao xong
/// AuthInterceptor, nhung refresh-token lai can goi qua Dio.
Future<String?> _refreshAccessToken(
  SecureStorageService secureStorage,
  String refreshToken,
) async {
  final Dio bareDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));
  try {
    final Response<Map<String, dynamic>> response = await bareDio.post(
      ApiEndpoints.refreshToken,
      data: {'refresh_token': refreshToken},
    );
    final Map<String, dynamic>? data = response.data;
    final String? newAccessToken = data?['access_token'] as String?;
    final String? newRefreshToken = data?['refresh_token'] as String?;
    if (newAccessToken == null || newRefreshToken == null) return null;

    await secureStorage.saveTokens(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
    return newAccessToken;
  } catch (_) {
    return null;
  }
}
