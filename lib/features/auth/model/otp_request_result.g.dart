// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_request_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtpRequestResultImpl _$$OtpRequestResultImplFromJson(
        Map<String, dynamic> json) =>
    _$OtpRequestResultImpl(
      otpRequestId: json['otp_request_id'] as String,
      expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    );

Map<String, dynamic> _$$OtpRequestResultImplToJson(
        _$OtpRequestResultImpl instance) =>
    <String, dynamic>{
      'otp_request_id': instance.otpRequestId,
      'expires_in_seconds': instance.expiresInSeconds,
    };
