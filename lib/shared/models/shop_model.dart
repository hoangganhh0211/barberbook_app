import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

/// Thong tin 1 tiem cat toc - doc tu bang `shops` trong Supabase (xem
/// `supabase/schema_shops.sql`). Dung chung o Home, Tim kiem, Chi tiet
/// Tiem, Booking - vi vay dat o `shared/models`, KHONG thuoc rieng 1 feature.
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
