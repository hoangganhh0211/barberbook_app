import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/review_model.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho du lieu Danh gia.
class ReviewService {
  ReviewService(this._client);

  final SupabaseClient _client;

  /// Tao 1 danh gia moi cho 1 booking DA HOAN TAT (`status = 'completed'`).
  /// RLS trong `supabase/schema_reviews.sql` se tu chan neu booking chua
  /// hoan tat hoac khong phai cua khach dang dang nhap - KHONG can kiem tra
  /// lai o Flutter, chi can xu ly loi tra ve neu co (xem `ReviewRepository`).
  Future<ReviewModel> createReview({
    required String bookingId,
    required String shopId,
    required int rating,
    String? comment,
  }) async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) {
      throw StateError('Chưa đăng nhập - không thể gửi đánh giá.');
    }

    final Map<String, dynamic> row = await _client
        .from('reviews')
        .insert({
          'booking_id': bookingId,
          'customer_id': customerId,
          'shop_id': shopId,
          'rating': rating,
          'comment': comment,
        })
        .select()
        .single();

    return ReviewModel.fromJson(row);
  }

  /// Danh sach danh gia cua 1 tiem, moi nhat len dau.
  Future<List<ReviewModel>> fetchReviewsByShop(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('reviews')
        .select()
        .eq('shop_id', shopId)
        .order('created_at', ascending: false);

    return rows.map(ReviewModel.fromJson).toList();
  }
}