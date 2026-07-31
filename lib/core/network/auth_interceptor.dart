import 'package:dio/dio.dart';

import 'package:barberbook_app/core/storage/secure_storage_service.dart';

/// Ket qua refresh token: token moi hoac null neu refresh that bai
/// (refresh_token cung da het han -> bat buoc dang xuat that su).
typedef TokenRefresher = Future<String?> Function(String refreshToken);

/// Interceptor:
/// 1. Gan `Authorization: Bearer <access_token>` vao moi request.
/// 2. Khi gap 401: goi [TokenRefresher] de lay access_token moi, sau do tu
///    dong retry lai request goc - UI/Provider hoan toan khong biet co
///    chuyen refresh dang dien ra ben duoi.
///
/// Dung `QueuedInterceptor` (khong phai `Interceptor` thuong) de dam bao:
/// neu 5 request cung 401 mot luc, chi 1 lan refresh duoc thuc hien, 4
/// request con lai se "cho" va duoc retry voi token moi - dung theo yeu cau
/// "refresh_token... rotation moi lan refresh de chong replay attack".
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    required this.secureStorage,
    required this.tokenRefresher,
    required this.onSessionExpired,
    required Dio retryDio,
  }) : _retryDio = retryDio;

  final SecureStorageService secureStorage;
  final TokenRefresher tokenRefresher;

  /// Goi khi refresh token that bai hoan toan -> bat buoc dieu huong ve
  /// man Login. Duoc truyen tu ben ngoai (thay vi import GoRouter truc
  /// tiep) de giu AuthInterceptor khong phu thuoc tang UI/Routing.
  final void Function() onSessionExpired;

  /// Dio "sach" (khong gan lai AuthInterceptor) dung de retry request sau
  /// khi da co token moi - tranh vong lap vo han neu retry lai bi 401.
  final Dio _retryDio;

  static const _extraKeyIsRetry = 'barberbook_is_retry';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? accessToken = await secureStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final bool isUnauthorized = err.response?.statusCode == 401;
    final bool alreadyRetried =
        err.requestOptions.extra[_extraKeyIsRetry] == true;

    if (!isUnauthorized || alreadyRetried) {
      handler.next(err);
      return;
    }

    final String? refreshToken = await secureStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await secureStorage.clearTokens();
      onSessionExpired();
      handler.next(err);
      return;
    }

    try {
      final String? newAccessToken = await tokenRefresher(refreshToken);
      if (newAccessToken == null) {
        await secureStorage.clearTokens();
        onSessionExpired();
        handler.next(err);
        return;
      }

      final RequestOptions retryOptions = err.requestOptions
        ..headers['Authorization'] = 'Bearer $newAccessToken'
        ..extra[_extraKeyIsRetry] = true;

      final Response<dynamic> response = await _retryDio.fetch<dynamic>(retryOptions);
      handler.resolve(response);
    } catch (_) {
      await secureStorage.clearTokens();
      onSessionExpired();
      handler.next(err);
    }
  }
}
