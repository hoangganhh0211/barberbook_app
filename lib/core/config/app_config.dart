/// Cau hinh moi truong cua app - lay tu bien --dart-define khi build.
///
/// Vi du chay/build voi environment cu the:
/// ```
/// flutter run --dart-define=API_BASE_URL=https://api-dev.barberbook.vn/api/v1
/// flutter build apk --dart-define=API_BASE_URL=https://api.barberbook.vn/api/v1
/// ```
///
/// Khong hardcode URL truc tiep trong DioClient hay bat ky Service nao -
/// moi noi can baseUrl deu phai doc qua [AppConfig.apiBaseUrl].
abstract class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-dev.barberbook.vn/api/v1',
  );

  /// Timeout theo dung "Timeout Policy" trong tai lieu (muc 3.2.1): 30 giay.
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const bool enableNetworkLogging = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGGING',
    defaultValue: true,
  );
}
