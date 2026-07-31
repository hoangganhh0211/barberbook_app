import 'package:barberbook_app/core/error/exceptions.dart';

/// [Failure] la representation cua loi o tang Repository/Provider/UI.
///
/// Khac voi [AppException] (chi ton tai o tang Service, mang tinh ky thuat),
/// [Failure] la thu duy nhat ma Provider/UI duoc phep biet den. Nho vay:
/// - UI khong bao gio import Dio hay bat ky thu gi thuoc tang network.
/// - De unit test Provider: chi can gia lap Repository tra ve Failure,
///   khong can mock nguyen ca Dio.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.errorCode});
  final String? errorCode;
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

final class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Ham dung chung o moi Repository de convert [AppException] -> [Failure].
///
/// Vi du su dung trong Repository (xem [Result] tai `core/utils/result.dart`):
/// ```dart
/// try {
///   final data = await _apiService.login(...);
///   return Success(data);
/// } on AppException catch (e) {
///   return ResultFailure(mapExceptionToFailure(e));
/// }
/// ```
Failure mapExceptionToFailure(AppException exception) {
  return switch (exception) {
    NoInternetException() => NetworkFailure(exception.message),
    RequestTimeoutException() => TimeoutFailure(exception.message),
    UnauthorizedException() => AuthFailure(exception.message),
    ForbiddenException() => PermissionFailure(exception.message),
    ConflictException() => ConflictFailure(exception.message),
    ServerException() => ServerFailure(exception.message, errorCode: exception.errorCode),
    UnknownException() => UnknownFailure(exception.message),
  };
}
