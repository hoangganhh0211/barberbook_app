// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_request_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtpRequestResult _$OtpRequestResultFromJson(Map<String, dynamic> json) {
  return _OtpRequestResult.fromJson(json);
}

/// @nodoc
mixin _$OtpRequestResult {
  @JsonKey(name: 'otp_request_id')
  String get otpRequestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_in_seconds')
  int get expiresInSeconds => throw _privateConstructorUsedError;

  /// Serializes this OtpRequestResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OtpRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OtpRequestResultCopyWith<OtpRequestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtpRequestResultCopyWith<$Res> {
  factory $OtpRequestResultCopyWith(
          OtpRequestResult value, $Res Function(OtpRequestResult) then) =
      _$OtpRequestResultCopyWithImpl<$Res, OtpRequestResult>;
  @useResult
  $Res call(
      {@JsonKey(name: 'otp_request_id') String otpRequestId,
      @JsonKey(name: 'expires_in_seconds') int expiresInSeconds});
}

/// @nodoc
class _$OtpRequestResultCopyWithImpl<$Res, $Val extends OtpRequestResult>
    implements $OtpRequestResultCopyWith<$Res> {
  _$OtpRequestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OtpRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otpRequestId = null,
    Object? expiresInSeconds = null,
  }) {
    return _then(_value.copyWith(
      otpRequestId: null == otpRequestId
          ? _value.otpRequestId
          : otpRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      expiresInSeconds: null == expiresInSeconds
          ? _value.expiresInSeconds
          : expiresInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OtpRequestResultImplCopyWith<$Res>
    implements $OtpRequestResultCopyWith<$Res> {
  factory _$$OtpRequestResultImplCopyWith(_$OtpRequestResultImpl value,
          $Res Function(_$OtpRequestResultImpl) then) =
      __$$OtpRequestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'otp_request_id') String otpRequestId,
      @JsonKey(name: 'expires_in_seconds') int expiresInSeconds});
}

/// @nodoc
class __$$OtpRequestResultImplCopyWithImpl<$Res>
    extends _$OtpRequestResultCopyWithImpl<$Res, _$OtpRequestResultImpl>
    implements _$$OtpRequestResultImplCopyWith<$Res> {
  __$$OtpRequestResultImplCopyWithImpl(_$OtpRequestResultImpl _value,
      $Res Function(_$OtpRequestResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of OtpRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otpRequestId = null,
    Object? expiresInSeconds = null,
  }) {
    return _then(_$OtpRequestResultImpl(
      otpRequestId: null == otpRequestId
          ? _value.otpRequestId
          : otpRequestId // ignore: cast_nullable_to_non_nullable
              as String,
      expiresInSeconds: null == expiresInSeconds
          ? _value.expiresInSeconds
          : expiresInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtpRequestResultImpl implements _OtpRequestResult {
  const _$OtpRequestResultImpl(
      {@JsonKey(name: 'otp_request_id') required this.otpRequestId,
      @JsonKey(name: 'expires_in_seconds') required this.expiresInSeconds});

  factory _$OtpRequestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtpRequestResultImplFromJson(json);

  @override
  @JsonKey(name: 'otp_request_id')
  final String otpRequestId;
  @override
  @JsonKey(name: 'expires_in_seconds')
  final int expiresInSeconds;

  @override
  String toString() {
    return 'OtpRequestResult(otpRequestId: $otpRequestId, expiresInSeconds: $expiresInSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpRequestResultImpl &&
            (identical(other.otpRequestId, otpRequestId) ||
                other.otpRequestId == otpRequestId) &&
            (identical(other.expiresInSeconds, expiresInSeconds) ||
                other.expiresInSeconds == expiresInSeconds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, otpRequestId, expiresInSeconds);

  /// Create a copy of OtpRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpRequestResultImplCopyWith<_$OtpRequestResultImpl> get copyWith =>
      __$$OtpRequestResultImplCopyWithImpl<_$OtpRequestResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtpRequestResultImplToJson(
      this,
    );
  }
}

abstract class _OtpRequestResult implements OtpRequestResult {
  const factory _OtpRequestResult(
      {@JsonKey(name: 'otp_request_id') required final String otpRequestId,
      @JsonKey(name: 'expires_in_seconds')
      required final int expiresInSeconds}) = _$OtpRequestResultImpl;

  factory _OtpRequestResult.fromJson(Map<String, dynamic> json) =
      _$OtpRequestResultImpl.fromJson;

  @override
  @JsonKey(name: 'otp_request_id')
  String get otpRequestId;
  @override
  @JsonKey(name: 'expires_in_seconds')
  int get expiresInSeconds;

  /// Create a copy of OtpRequestResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OtpRequestResultImplCopyWith<_$OtpRequestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
