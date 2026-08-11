import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';
@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'customer_name') required String customerName,
    required int rating,
    String? comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);
}