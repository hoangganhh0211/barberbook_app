// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      serviceId: json['service_id'] as String,
      staffId: json['staff_id'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      status: _statusFromJson(json['status'] as String),
      totalPrice: (json['total_price'] as num).toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'service_id': instance.serviceId,
      'staff_id': instance.staffId,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
      'status': _statusToJson(instance.status),
      'total_price': instance.totalPrice,
      'note': instance.note,
    };
