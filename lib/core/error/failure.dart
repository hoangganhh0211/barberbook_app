import 'package:barberbook_app/core/error/exceptions.dart';


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
