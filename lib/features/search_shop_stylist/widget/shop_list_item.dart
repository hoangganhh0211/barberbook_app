import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_cover_image.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_status_badge.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// 1 dong trong danh sach Tiem - dung lai o ca tab "Tiem" (Chuc nang 2) va
/// section noi bat tren Home (Chuc nang 3), tranh dung lai UI khac nhau
/// cho cung 1 loai du lieu.
class ShopListItem extends StatelessWidget {
  const ShopListItem({required this.shop, required this.onTap, super.key});

  final ShopModel shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShopCoverImage(
              imageUrl: shop.coverImageUrl,
              width: 84,
              height: 84,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: AppTextStyles.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ShopStatusBadge(isOpen: shop.isOpen),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(shop.rating.toStringAsFixed(1), style: AppTextStyles.bodySecondary),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    shop.address,
                    style: AppTextStyles.bodySecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}