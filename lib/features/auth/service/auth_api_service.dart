import 'package:dio/dio.dart';

import 'package:barberbook_app/core/constants/api_endpoints.dart';
import 'package:barberbook_app/core/network/error_interceptor.dart';
import 'package:barberbook_app/features/auth/model/login_result.dart';
import 'package:barberbook_app/features/auth/model/otp_request_result.dart';
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

  /// Buoc 1 cua dang ky (US-AUTH-001): gui SDT + ho ten, server gui ma OTP
  /// ve dien thoai va tra ve `otp_request_id` de dung o buoc xac thuc.
  /// Dung LAI method nay cho ca hanh dong "Gui lai ma" (server tu coi day
  /// la 1 lan yeu cau OTP moi).
  Future<OtpRequestResult> requestRegisterOtp({
    required String phone,
    required String fullName,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        ApiEndpoints.registerRequestOtp,
        data: {'phone': phone, 'full_name': fullName},
      );
      return OtpRequestResult.fromJson(response.data!);
    } on DioException catch (e) {
      throw extractAppException(e);
    }
  }

  /// Buoc 2 cua dang ky: xac thuc ma OTP + tao mat khau. Thanh cong nghia
  /// la tai khoan da duoc tao VA dang nhap luon (giong het response cua
  /// `login()`) - UX chuan cho luong dang ky, khong bat nguoi dung dang
  /// nhap lai lan nua ngay sau khi vua dang ky xong.
  Future<LoginResult> verifyOtpAndRegister({
    required String otpRequestId,
    required String otpCode,
    required String password,
  }) async {
    try {
      final Response<Map<String, dynamic>> response = await _dio.post(
        ApiEndpoints.verifyOtp,
        data: {
          'otp_request_id': otpRequestId,
          'otp_code': otpCode,
          'password': password,
        },
      );
      return LoginResult.fromJson(response.data!);
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
