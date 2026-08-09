import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';

/// Sao danh gia CO THE CHON - dung khi viet review moi.
class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    required this.rating,
    required this.onChanged,
    this.size = 36,
    super.key,
  });

  /// 0-5, 0 = chua chon sao nao.
  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final int starValue = index + 1;
        final bool filled = starValue <= rating;
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppColors.warning,
            size: size,
          ),
        );
      }),
    );
  }
}

/// Sao danh gia CHI HIEN THI (khong tuong tac) - dung o danh sach review va
/// [ShopDetailScreen]. Lam tron ve so nguyen gan nhat (khong ve nua sao,
/// giu don gian).
class StarRatingDisplay extends StatelessWidget {
  const StarRatingDisplay({required this.rating, this.size = 16, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final int fullStars = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Icon(
          index < fullStars ? Icons.star_rounded : Icons.star_border_rounded,
          color: AppColors.warning,
          size: size,
        ),
      ),
    );
  }
}