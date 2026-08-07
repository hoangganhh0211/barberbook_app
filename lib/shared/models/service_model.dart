import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';

/// 1 dich vu cua tiem (cat toc, uon, nhuom...) - doc tu bang `services`
/// (xem `supabase/schema_services_staff.sql`). Dung o Buoc 1 luong Dat lich
/// (US-BOOKING-009), va se dung lai o tab "Dich vu" cua Chi tiet Tiem sau
/// nay - vi vay dat o `shared/models`.
@freezed
class ServiceModel with _$ServiceModel {
  const factory ServiceModel({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
    @JsonKey(name: 'image_url') String? imageUrl,
  }) = _ServiceModel;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
}