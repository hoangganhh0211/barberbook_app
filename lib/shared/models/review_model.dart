import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

/// 1 danh gia cua khach hang - doc/ghi tu bang `reviews` (xem
/// `supabase/schema_reviews.sql`). `customerName` la snapshot tu Database
/// (trigger tu dong dien), KHONG phai du lieu client tu gui.
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