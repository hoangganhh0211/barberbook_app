import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_cover_image.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Card Tiem dang doc (anh tren, thong tin duoi) - dung cho section cuon
/// ngang "Tiem noi bat" tren Home. KHAC voi [ShopListItem] (dang ngang, tab
/// Tiem) - 2 layout khac nhau cho cung 1 loai du lieu, ly do can 2 widget
/// rieng thay vi 1 widget "linh hoat qua muc".
class FeaturedShopCard extends StatelessWidget {
  const FeaturedShopCard({required this.shop, required this.onTap, super.key});

  final ShopModel shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShopCoverImage(
              imageUrl: shop.coverImageUrl,
              width: 160,
              height: 100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text(shop.rating.toStringAsFixed(1), style: AppTextStyles.caption),
                    ],
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