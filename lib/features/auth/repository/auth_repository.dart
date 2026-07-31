import 'package:barberbook_app/core/error/exceptions.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/storage/secure_storage_service.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/login_result.dart';
import 'package:barberbook_app/features/auth/model/otp_request_result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/service/auth_api_service.dart';

/// Interface truu tuong - moi Provider/Controller PHAI phu thuoc vao day,
/// KHONG phu thuoc truc tiep [AuthRepositoryImpl] (Dependency Inversion) -
/// de de thay the bang Fake khi viet unit test cho [AuthController].
abstract class AuthRepository {
  Future<Result<LoginResult>> login({required String phone, required String password});

  Future<Result<UserSession>> getCurrentUser();

  /// Buoc 1 dang ky: gui SDT + ho ten, nhan ve `otp_request_id`.
  Future<Result<OtpRequestResult>> requestRegisterOtp({
    required String phone,
    required String fullName,
  });

  /// Buoc 2 dang ky: xac thuc OTP + tao mat khau. Thanh cong = tai khoan
  /// duoc tao VA dang nhap luon, nen cung luu token nhu [login].
  Future<Result<LoginResult>> verifyOtpAndRegister({
    required String otpRequestId,
    required String otpCode,
    required String password,
  });

  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApiService apiService,
    required SecureStorageService secureStorage,
  })  : _apiService = apiService,
        _secureStorage = secureStorage;

  final AuthApiService _apiService;
  final SecureStorageService _secureStorage;

  @override
  Future<Result<LoginResult>> login({
    required String phone,
    required String password,
  }) async {
    try {
      final LoginResult result = await _apiService.login(phone: phone, password: password);
      await _secureStorage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return Success(result);
    } on AppException catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<UserSession>> getCurrentUser() async {
    try {
      final UserSession user = await _apiService.fetchCurrentUser();
      return Success(user);
    } on AppException catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<OtpRequestResult>> requestRegisterOtp({
    required String phone,
    required String fullName,
  }) async {
    try {
      final OtpRequestResult result = await _apiService.requestRegisterOtp(
        phone: phone,
        fullName: fullName,
      );
      return Success(result);
    } on AppException catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Result<LoginResult>> verifyOtpAndRegister({
    required String otpRequestId,
    required String otpCode,
    required String password,
  }) async {
    try {
      final LoginResult result = await _apiService.verifyOtpAndRegister(
        otpRequestId: otpRequestId,
        otpCode: otpCode,
        password: password,
      );
      // Dang ky thanh cong = dang nhap luon, nen luu token GIONG HET logic
      // cua `login()` - khong duoc quen buoc nay, neu khong user se bi dua
      // ve man Login ngay sau khi vua dang ky xong (khong co token de
      // AuthController._restoreSession() nhan dien).
      await _secureStorage.saveTokens(
        accessToken: result.tokens.accessToken,
        refreshToken: result.tokens.refreshToken,
      );
      return Success(result);
    } on AppException catch (e) {
      return ResultFailure(mapExceptionToFailure(e));
    }
  }

  @override
  Future<void> logout() async {
    // Best-effort: du goi API that bai (mat mang, server loi...), VAN PHAI
    // xoa token local trong `finally` - khong duoc de nguoi dung "ket ket"
    // o trang thai da bam Dang xuat nhung token cu van con luu tren may.
    try {
      await _apiService.logout();
    } catch (_) {
      // Bo qua loi - day la best-effort, khong anh huong luong dang xuat local.
    } finally {
      await _secureStorage.clearTokens();
    }
  }
}
