import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_request_result.freezed.dart';
part 'otp_request_result.g.dart';

/// Response cua API "yeu cau gui OTP" (`ApiEndpoints.registerRequestOtp`).
///
/// - `otpRequestId`: dinh danh cho lan yeu cau OTP nay - PHAI gui kem khi
///   goi API xac thuc OTP (`ApiEndpoints.verifyOtp`), giup BE biet dang xac
///   thuc cho lan gui nao (tranh truong hop user bam "Gui lai" nhieu lan).
/// - `expiresInSeconds`: thoi gian OTP con hieu luc, DO SERVER QUY DINH -
///   man OtpScreen dung gia tri nay de dem nguoc, KHONG hardcode 60s o FE
///   (tranh sai lech neu BE doi policy).
@freezed
class OtpRequestResult with _$OtpRequestResult {
  const factory OtpRequestResult({
    @JsonKey(name: 'otp_request_id') required String otpRequestId,
    @JsonKey(name: 'expires_in_seconds') required int expiresInSeconds,
  }) = _OtpRequestResult;

  factory OtpRequestResult.fromJson(Map<String, dynamic> json) =>
      _$OtpRequestResultFromJson(json);
}
