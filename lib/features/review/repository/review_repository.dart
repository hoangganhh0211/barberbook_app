import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/review/service/review_service.dart';
import 'package:barberbook_app/shared/models/review_model.dart';

abstract class ReviewRepository {
  Future<Result<ReviewModel>> createReview({
    required String bookingId,
    required String shopId,
    required int rating,
    String? comment,
  });

  Future<Result<List<ReviewModel>>> fetchReviewsByShop(String shopId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl(this._service);

  final ReviewService _service;

  @override
  Future<Result<ReviewModel>> createReview({
    required String bookingId,
    required String shopId,
    required int rating,
    String? comment,
  }) async {
    try {
      final ReviewModel review = await _service.createReview(
        bookingId: bookingId,
        shopId: shopId,
        rating: rating,
        comment: comment,
      );
      return Success(review);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return const ResultFailure(ServerFailure('Bạn đã đánh giá cho lịch hẹn này rồi.'));
      }
      if (e.code == '42501') {
        return const ResultFailure(
          PermissionFailure('Chỉ có thể đánh giá sau khi dịch vụ đã hoàn tất.'),
        );
      }
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<List<ReviewModel>>> fetchReviewsByShop(String shopId) async {
    try {
      final List<ReviewModel> reviews = await _service.fetchReviewsByShop(shopId);
      return Success(reviews);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }
}