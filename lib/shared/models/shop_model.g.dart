// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShopModelImpl _$$ShopModelImplFromJson(Map<String, dynamic> json) =>
    _$ShopModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      coverImageUrl: json['cover_image_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      isOpen: json['is_open'] as bool? ?? true,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ShopModelImplToJson(_$ShopModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'phone': instance.phone,
      'cover_image_url': instance.coverImageUrl,
      'rating': instance.rating,
      'is_open': instance.isOpen,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
