import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/review/repository/review_repository.dart';
import 'package:barberbook_app/features/review/service/review_service.dart';
import 'package:barberbook_app/shared/models/review_model.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService(ref.watch(supabaseClientProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewServiceProvider));
});
final reviewListProvider = FutureProvider.family<List<ReviewModel>, String>((ref, shopId) async {
  final result = await ref.watch(reviewRepositoryProvider).fetchReviewsByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});