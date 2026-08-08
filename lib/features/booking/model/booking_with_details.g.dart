// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_with_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingWithDetailsImpl _$$BookingWithDetailsImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingWithDetailsImpl(
      id: json['id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: _statusFromJson(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      shop: BookingShopInfo.fromJson(json['shops'] as Map<String, dynamic>),
      service:
          BookingServiceInfo.fromJson(json['services'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingWithDetailsImplToJson(
        _$BookingWithDetailsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'status': _statusToJson(instance.status),
      'total_price': instance.totalPrice,
      'shops': instance.shop,
      'services': instance.service,
    };

_$BookingShopInfoImpl _$$BookingShopInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingShopInfoImpl(
      name: json['name'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
    );

Map<String, dynamic> _$$BookingShopInfoImplToJson(
        _$BookingShopInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cover_image_url': instance.coverImageUrl,
    };

_$BookingServiceInfoImpl _$$BookingServiceInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingServiceInfoImpl(
      name: json['name'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$$BookingServiceInfoImplToJson(
        _$BookingServiceInfoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration_minutes': instance.durationMinutes,
    };
