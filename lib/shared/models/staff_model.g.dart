// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffModelImpl _$$StaffModelImplFromJson(Map<String, dynamic> json) =>
    _$StaffModelImpl(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      profileId: json['profile_id'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$StaffModelImplToJson(_$StaffModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'rating': instance.rating,
      'profile_id': instance.profileId,
      'is_active': instance.isActive,
    };
