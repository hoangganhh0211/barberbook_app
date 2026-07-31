/// Cac exception tang Service - duoc nem (throw) tu `XxxApiService` khi goi
/// Dio that bai. Repository se catch nhung exception nay va convert sang
/// [Failure] (xem `failure.dart`) de UI/Provider khong bao gio phai biet
/// ve chi tiet ky thuat cua Dio.
library;

/// Base class cho tat ca exception cua app - cho phep catch chung khi can.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Khong co ket noi Internet (truoc khi request duoc gui di).
final class NoInternetException extends AppException {
  const NoInternetException([
    super.message = 'Khong co ket noi mang. Vui long kiem tra Internet.',
  ]);
}

/// Vuot qua Timeout Policy 30s theo tai lieu (muc 3.2.1).
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'Yeu cau qua thoi gian cho. Vui long thu lai.',
  ]);
}

/// Loi tra ve tu server voi status code va message cu the (400, 422...).
final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    required super.message,
    this.errorCode,
  });

  final int statusCode;

  /// Ma loi nghiep vu do BE dinh nghia, vd: "OTP_EXPIRED", "SLOT_CONFLICT".
  /// Dung de UI xu ly rieng tung truong hop thay vi chi hien message chung.
  final String? errorCode;
}

/// Loi 401 - token het han/khong hop le, chua the tu refresh duoc.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Phien dang nhap da het han. Vui long dang nhap lai.',
  ]);
}

/// Loi 403 - khong du quyen thao tac (theo bang RBAC).
final class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = 'Ban khong co quyen thuc hien thao tac nay.',
  ]);
}

/// Loi 409 - xung dot du lieu (vd: 2 admin cung sua 1 nhan vien, slot vua bi
/// nguoi khac dat truoc - dung theo muc "Concurrency & Conflict" trong spec).
final class ConflictException extends AppException {
  const ConflictException([
    super.message = 'Du lieu vua duoc cap nhat boi nguoi khac. Vui long tai lai.',
  ]);
}

/// Loi khong xac dinh / khong luong truoc duoc (parse response that bai...).
final class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Da co loi xay ra. Vui long thu lai sau.',
  ]);
}
