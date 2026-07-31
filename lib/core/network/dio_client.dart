import 'package:dio/dio.dart';

import 'package:barberbook_app/core/config/app_config.dart';
import 'package:barberbook_app/core/network/auth_interceptor.dart';
import 'package:barberbook_app/core/network/error_interceptor.dart';
import 'package:barberbook_app/core/storage/secure_storage_service.dart';

/// Factory tao ra [Dio] instance da duoc cau hinh day du:
/// baseUrl, timeout, AuthInterceptor (tu dong gan/refresh token),
/// ErrorInterceptor (chuan hoa loi), va LogInterceptor (chi bat khi debug).
///
/// Moi `XxxApiService` trong cac feature deu nhan [Dio] duoc tao boi class
/// nay qua constructor injection (Riverpod provider) - KHONG tu tao `Dio()`
/// rieng, de dam bao toan bo app dung chung 1 cau hinh network.
class DioClient {
  DioClient({
    required SecureStorageService secureStorage,
    required TokenRefresher tokenRefresher,
    required void Function() onSessionExpired,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        contentType: 'application/json',
      ),
    );

    // Dio "sach" khong gan AuthInterceptor - chi dung noi bo de:
    // (1) goi API refresh-token, (2) retry request sau khi co token moi.
    // Neu dung chinh `_dio` (co AuthInterceptor) cho 2 viec nay se gay
    // vong lap vo han khi refresh-token cung tra ve 401.
    final Dio bareDio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(
        secureStorage: secureStorage,
        tokenRefresher: tokenRefresher,
        onSessionExpired: onSessionExpired,
        retryDio: bareDio,
      ),
      ErrorInterceptor(),
      if (AppConfig.enableNetworkLogging)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  late final Dio _dio;

  Dio get dio => _dio;
}
