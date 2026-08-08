// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_with_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingWithDetails _$BookingWithDetailsFromJson(Map<String, dynamic> json) {
  return _BookingWithDetails.fromJson(json);
}

/// @nodoc
mixin _$BookingWithDetails {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  DateTime get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  DateTime get endTime => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  BookingStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_price')
  double get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'shops')
  BookingShopInfo get shop => throw _privateConstructorUsedError;
  @JsonKey(name: 'services')
  BookingServiceInfo get service => throw _privateConstructorUsedError;

  /// Serializes this BookingWithDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingWithDetailsCopyWith<BookingWithDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingWithDetailsCopyWith<$Res> {
  factory $BookingWithDetailsCopyWith(
          BookingWithDetails value, $Res Function(BookingWithDetails) then) =
      _$BookingWithDetailsCopyWithImpl<$Res, BookingWithDetails>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      BookingStatus status,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'shops') BookingShopInfo shop,
      @JsonKey(name: 'services') BookingServiceInfo service});

  $BookingShopInfoCopyWith<$Res> get shop;
  $BookingServiceInfoCopyWith<$Res> get service;
}

/// @nodoc
class _$BookingWithDetailsCopyWithImpl<$Res, $Val extends BookingWithDetails>
    implements $BookingWithDetailsCopyWith<$Res> {
  _$BookingWithDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? shop = null,
    Object? service = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      shop: null == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as BookingShopInfo,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as BookingServiceInfo,
    ) as $Val);
  }

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingShopInfoCopyWith<$Res> get shop {
    return $BookingShopInfoCopyWith<$Res>(_value.shop, (value) {
      return _then(_value.copyWith(shop: value) as $Val);
    });
  }

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookingServiceInfoCopyWith<$Res> get service {
    return $BookingServiceInfoCopyWith<$Res>(_value.service, (value) {
      return _then(_value.copyWith(service: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BookingWithDetailsImplCopyWith<$Res>
    implements $BookingWithDetailsCopyWith<$Res> {
  factory _$$BookingWithDetailsImplCopyWith(_$BookingWithDetailsImpl value,
          $Res Function(_$BookingWithDetailsImpl) then) =
      __$$BookingWithDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'start_time') DateTime startTime,
      @JsonKey(name: 'end_time') DateTime endTime,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      BookingStatus status,
      @JsonKey(name: 'total_price') double totalPrice,
      @JsonKey(name: 'shops') BookingShopInfo shop,
      @JsonKey(name: 'services') BookingServiceInfo service});

  @override
  $BookingShopInfoCopyWith<$Res> get shop;
  @override
  $BookingServiceInfoCopyWith<$Res> get service;
}

/// @nodoc
class __$$BookingWithDetailsImplCopyWithImpl<$Res>
    extends _$BookingWithDetailsCopyWithImpl<$Res, _$BookingWithDetailsImpl>
    implements _$$BookingWithDetailsImplCopyWith<$Res> {
  __$$BookingWithDetailsImplCopyWithImpl(_$BookingWithDetailsImpl _value,
      $Res Function(_$BookingWithDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? totalPrice = null,
    Object? shop = null,
    Object? service = null,
  }) {
    return _then(_$BookingWithDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      shop: null == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as BookingShopInfo,
      service: null == service
          ? _value.service
          : service // ignore: cast_nullable_to_non_nullable
              as BookingServiceInfo,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingWithDetailsImpl implements _BookingWithDetails {
  const _$BookingWithDetailsImpl(
      {required this.id,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      required this.status,
      @JsonKey(name: 'total_price') required this.totalPrice,
      @JsonKey(name: 'shops') required this.shop,
      @JsonKey(name: 'services') required this.service});

  factory _$BookingWithDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingWithDetailsImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @override
  @JsonKey(name: 'end_time')
  final DateTime endTime;
  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final BookingStatus status;
  @override
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @override
  @JsonKey(name: 'shops')
  final BookingShopInfo shop;
  @override
  @JsonKey(name: 'services')
  final BookingServiceInfo service;

  @override
  String toString() {
    return 'BookingWithDetails(id: $id, startTime: $startTime, endTime: $endTime, status: $status, totalPrice: $totalPrice, shop: $shop, service: $service)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingWithDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.shop, shop) || other.shop == shop) &&
            (identical(other.service, service) || other.service == service));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, startTime, endTime, status, totalPrice, shop, service);

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingWithDetailsImplCopyWith<_$BookingWithDetailsImpl> get copyWith =>
      __$$BookingWithDetailsImplCopyWithImpl<_$BookingWithDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingWithDetailsImplToJson(
      this,
    );
  }
}

abstract class _BookingWithDetails implements BookingWithDetails {
  const factory _BookingWithDetails(
      {required final String id,
      @JsonKey(name: 'start_time') required final DateTime startTime,
      @JsonKey(name: 'end_time') required final DateTime endTime,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      required final BookingStatus status,
      @JsonKey(name: 'total_price') required final double totalPrice,
      @JsonKey(name: 'shops') required final BookingShopInfo shop,
      @JsonKey(name: 'services')
      required final BookingServiceInfo service}) = _$BookingWithDetailsImpl;

  factory _BookingWithDetails.fromJson(Map<String, dynamic> json) =
      _$BookingWithDetailsImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'start_time')
  DateTime get startTime;
  @override
  @JsonKey(name: 'end_time')
  DateTime get endTime;
  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  BookingStatus get status;
  @override
  @JsonKey(name: 'total_price')
  double get totalPrice;
  @override
  @JsonKey(name: 'shops')
  BookingShopInfo get shop;
  @override
  @JsonKey(name: 'services')
  BookingServiceInfo get service;

  /// Create a copy of BookingWithDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingWithDetailsImplCopyWith<_$BookingWithDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingShopInfo _$BookingShopInfoFromJson(Map<String, dynamic> json) {
  return _BookingShopInfo.fromJson(json);
}

/// @nodoc
mixin _$BookingShopInfo {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl => throw _privateConstructorUsedError;

  /// Serializes this BookingShopInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingShopInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingShopInfoCopyWith<BookingShopInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingShopInfoCopyWith<$Res> {
  factory $BookingShopInfoCopyWith(
          BookingShopInfo value, $Res Function(BookingShopInfo) then) =
      _$BookingShopInfoCopyWithImpl<$Res, BookingShopInfo>;
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'cover_image_url') String? coverImageUrl});
}

/// @nodoc
class _$BookingShopInfoCopyWithImpl<$Res, $Val extends BookingShopInfo>
    implements $BookingShopInfoCopyWith<$Res> {
  _$BookingShopInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingShopInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coverImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingShopInfoImplCopyWith<$Res>
    implements $BookingShopInfoCopyWith<$Res> {
  factory _$$BookingShopInfoImplCopyWith(_$BookingShopInfoImpl value,
          $Res Function(_$BookingShopInfoImpl) then) =
      __$$BookingShopInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'cover_image_url') String? coverImageUrl});
}

/// @nodoc
class __$$BookingShopInfoImplCopyWithImpl<$Res>
    extends _$BookingShopInfoCopyWithImpl<$Res, _$BookingShopInfoImpl>
    implements _$$BookingShopInfoImplCopyWith<$Res> {
  __$$BookingShopInfoImplCopyWithImpl(
      _$BookingShopInfoImpl _value, $Res Function(_$BookingShopInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingShopInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? coverImageUrl = freezed,
  }) {
    return _then(_$BookingShopInfoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingShopInfoImpl implements _BookingShopInfo {
  const _$BookingShopInfoImpl(
      {required this.name,
      @JsonKey(name: 'cover_image_url') this.coverImageUrl});

  factory _$BookingShopInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingShopInfoImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'cover_image_url')
  final String? coverImageUrl;

  @override
  String toString() {
    return 'BookingShopInfo(name: $name, coverImageUrl: $coverImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingShopInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, coverImageUrl);

  /// Create a copy of BookingShopInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingShopInfoImplCopyWith<_$BookingShopInfoImpl> get copyWith =>
      __$$BookingShopInfoImplCopyWithImpl<_$BookingShopInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingShopInfoImplToJson(
      this,
    );
  }
}

abstract class _BookingShopInfo implements BookingShopInfo {
  const factory _BookingShopInfo(
          {required final String name,
          @JsonKey(name: 'cover_image_url') final String? coverImageUrl}) =
      _$BookingShopInfoImpl;

  factory _BookingShopInfo.fromJson(Map<String, dynamic> json) =
      _$BookingShopInfoImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'cover_image_url')
  String? get coverImageUrl;

  /// Create a copy of BookingShopInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingShopInfoImplCopyWith<_$BookingShopInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingServiceInfo _$BookingServiceInfoFromJson(Map<String, dynamic> json) {
  return _BookingServiceInfo.fromJson(json);
}

/// @nodoc
mixin _$BookingServiceInfo {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Serializes this BookingServiceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingServiceInfoCopyWith<BookingServiceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingServiceInfoCopyWith<$Res> {
  factory $BookingServiceInfoCopyWith(
          BookingServiceInfo value, $Res Function(BookingServiceInfo) then) =
      _$BookingServiceInfoCopyWithImpl<$Res, BookingServiceInfo>;
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'duration_minutes') int durationMinutes});
}

/// @nodoc
class _$BookingServiceInfoCopyWithImpl<$Res, $Val extends BookingServiceInfo>
    implements $BookingServiceInfoCopyWith<$Res> {
  _$BookingServiceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMinutes = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingServiceInfoImplCopyWith<$Res>
    implements $BookingServiceInfoCopyWith<$Res> {
  factory _$$BookingServiceInfoImplCopyWith(_$BookingServiceInfoImpl value,
          $Res Function(_$BookingServiceInfoImpl) then) =
      __$$BookingServiceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, @JsonKey(name: 'duration_minutes') int durationMinutes});
}

/// @nodoc
class __$$BookingServiceInfoImplCopyWithImpl<$Res>
    extends _$BookingServiceInfoCopyWithImpl<$Res, _$BookingServiceInfoImpl>
    implements _$$BookingServiceInfoImplCopyWith<$Res> {
  __$$BookingServiceInfoImplCopyWithImpl(_$BookingServiceInfoImpl _value,
      $Res Function(_$BookingServiceInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMinutes = null,
  }) {
    return _then(_$BookingServiceInfoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMinutes: null == durationMinutes
          ? _value.durationMinutes
          : durationMinutes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingServiceInfoImpl implements _BookingServiceInfo {
  const _$BookingServiceInfoImpl(
      {required this.name,
      @JsonKey(name: 'duration_minutes') required this.durationMinutes});

  factory _$BookingServiceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingServiceInfoImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;

  @override
  String toString() {
    return 'BookingServiceInfo(name: $name, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingServiceInfoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, durationMinutes);

  /// Create a copy of BookingServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingServiceInfoImplCopyWith<_$BookingServiceInfoImpl> get copyWith =>
      __$$BookingServiceInfoImplCopyWithImpl<_$BookingServiceInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingServiceInfoImplToJson(
      this,
    );
  }
}

abstract class _BookingServiceInfo implements BookingServiceInfo {
  const factory _BookingServiceInfo(
      {required final String name,
      @JsonKey(name: 'duration_minutes')
      required final int durationMinutes}) = _$BookingServiceInfoImpl;

  factory _BookingServiceInfo.fromJson(Map<String, dynamic> json) =
      _$BookingServiceInfoImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'duration_minutes')
  int get durationMinutes;

  /// Create a copy of BookingServiceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingServiceInfoImplCopyWith<_$BookingServiceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
