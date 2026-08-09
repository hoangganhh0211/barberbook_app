import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/review/widget/star_rating.dart';
import 'package:barberbook_app/shared/models/review_model.dart';

/// 1 dong trong danh sach danh gia - dung o [ShopDetailScreen].
class ReviewListItem extends StatelessWidget {
  const ReviewListItem({required this.review, super.key});

  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  review.customerName.isEmpty ? 'Khách hàng' : review.customerName,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(Formatters.date(review.createdAt), style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 4),
          StarRatingDisplay(rating: review.rating.toDouble(), size: 15),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(review.comment!, style: AppTextStyles.bodyRegular),
          ],
        ],
      ),
    );
  }
}