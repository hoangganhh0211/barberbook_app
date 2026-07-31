import 'package:dio/dio.dart';

import 'package:barberbook_app/core/constants/api_endpoints.dart';
import 'package:barberbook_app/core/network/error_interceptor.dart';
import 'package:barberbook_app/features/auth/model/login_result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';

/// Tang DUY NHAT trong feature Auth duoc phep import `package:dio`.
///
/// KHONG chua business logic (luu token vao SecureStorage, doi AuthState...)
/// - nhung viec do thuoc ve [AuthRepository]. Class nay chi lam 1 viec: goi
/// API va tra ve Model da parse san, hoac nem [AppException] (qua
/// [extractAppException]) neu that bai.
class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  Future<LoginResult> login({
    required String phone,
    required String password,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        ApiEndpoints.login,
        data: {'phone': phone, 'password': password},
      );
      return LoginResult.fromJson(response.data!);
    } on DioException catch (e) {
      throw extractAppException(e);
    }
  }

  /// Dung de khoi phuc phien dang nhap khi mo lai app (xem
  /// `AuthController._restoreSession()`) - access_token da duoc
  /// [AuthInterceptor] tu dong gan vao header, khong can truyen tay o day.
  Future<UserSession> fetchCurrentUser() async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.get(ApiEndpoints.me);
      return UserSession.fromJson(response.data!);
    } on DioException catch (e) {
      throw extractAppException(e);
    }
  }

  /// Best-effort: bao BE huy hieu luc refresh_token hien tai (server-side
  /// invalidation). Repository se KHONG throw loi nay ra ngoai - du API that
  /// bai, client van phai xoa token local va dang xuat (xem `AuthRepositoryImpl.logout`).
  Future<void> logout() async {
    try {
      await _dio.post<void>(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw extractAppException(e);
    }
  }
}
