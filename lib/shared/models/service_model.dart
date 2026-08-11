import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_model.freezed.dart';
part 'service_model.g.dart';
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