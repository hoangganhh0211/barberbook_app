// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveRequestModelImpl _$$LeaveRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaveRequestModelImpl(
      id: json['id'] as String,
      staffProfileId: json['staff_profile_id'] as String,
      shopId: json['shop_id'] as String,
      staffName: json['staff_name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      reason: json['reason'] as String?,
      status: _statusFromJson(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LeaveRequestModelImplToJson(
        _$LeaveRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'staff_profile_id': instance.staffProfileId,
      'shop_id': instance.shopId,
      'staff_name': instance.staffName,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'reason': instance.reason,
      'status': _statusToJson(instance.status),
      'created_at': instance.createdAt.toIso8601String(),
    };
