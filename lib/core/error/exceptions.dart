library;
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NoInternetException extends AppException {
  const NoInternetException([
    super.message = 'Khong co ket noi mang. Vui long kiem tra Internet.',
  ]);
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([
    super.message = 'Yeu cau qua thoi gian cho. Vui long thu lai.',
  ]);
}

final class ServerException extends AppException {
  const ServerException({
    required this.statusCode,
    required String message,
    this.errorCode,
  }) : super(message);

  final int statusCode;

  final String? errorCode;
}

/// Loi 401 
final class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'Phien dang nhap da het han. Vui long dang nhap lai.',
  ]);
}

/// Loi 403 
final class ForbiddenException extends AppException {
  const ForbiddenException([
    super.message = 'Ban khong co quyen thuc hien thao tac nay.',
  ]);
}

/// Loi 409 
final class ConflictException extends AppException {
  const ConflictException([
    super.message = 'Du lieu vua duoc cap nhat boi nguoi khac. Vui long tai lai.',
  ]);
}

final class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Da co loi xay ra. Vui long thu lai sau.',
  ]);
}
