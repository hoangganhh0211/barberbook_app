import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';
@freezed
class ShopModel with _$ShopModel {
  const factory ShopModel({
    required String id,
    required String name,
    String? description,
    required String address,
    String? phone,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @Default(0) double rating,
    @JsonKey(name: 'is_open') @Default(true) bool isOpen,
    double? latitude,
    double? longitude,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, dynamic> json) => _$ShopModelFromJson(json);
}
