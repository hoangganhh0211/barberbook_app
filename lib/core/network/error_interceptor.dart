import 'package:dio/dio.dart';

import 'package:barberbook_app/core/error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final AppException appException = _mapDioExceptionToAppException(err);
    // Reject voi AppException thay vi DioException goc, de tang tren
    // (ApiService) khong bao gio phai import package:dio.
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
        response: err.response,
      ),
    );
  }

  AppException _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const RequestTimeoutException();

      case DioExceptionType.connectionError:
        return const NoInternetException();

      case DioExceptionType.badResponse:
        return _mapBadResponse(err);

      case DioExceptionType.cancel:
        return const UnknownException('Yeu cau da bi huy.');

      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const UnknownException();
    }
  }

  AppException _mapBadResponse(DioException err) {
    final int? statusCode = err.response?.statusCode;
    final dynamic data = err.response?.data;

    // Quy uoc BE tra ve: { "message": "...", "error_code": "..." }
    final String message = (data is Map<String, dynamic> ? data['message'] as String? : null) ??
        'Da co loi xay ra. Vui long thu lai sau.';
    final String? errorCode =
        data is Map<String, dynamic> ? data['error_code'] as String? : null;

    return switch (statusCode) {
      401 => const UnauthorizedException(),
      403 => const ForbiddenException(),
      409 => const ConflictException(),
      _ => ServerException(
          statusCode: statusCode ?? 0,
          message: message,
          errorCode: errorCode,
        ),
    };
  }
}

/// Dung trong MOI ApiService (o khoi `catch (DioException e)`) de lay ra
/// [AppException] da duoc [ErrorInterceptor] chuan hoa san trong
/// `DioException.error` - tranh moi noi tu viet lai `e.error as AppException`
/// (va co the quen xu ly truong hop `e.error` khong phai AppException).
///
/// Vi du dung trong ApiService:
/// ```dart
/// try {
///   final res = await _dio.post(...);
///   return MyModel.fromJson(res.data);
/// } on DioException catch (e) {
///   throw extractAppException(e);
/// }
/// ```
AppException extractAppException(DioException error) {
  final Object? inner = error.error;
  return inner is AppException ? inner : const UnknownException();
}
