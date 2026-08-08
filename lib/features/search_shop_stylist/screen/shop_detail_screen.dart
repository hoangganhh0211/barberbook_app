import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_cover_image.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_detail_app_bar.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Man Chi tiet Tiem - vao tu [ShopListItem]/`FeaturedShopCard` (tab
/// Tiem/Home) qua `context.push(RoutePaths.customerShopDetail(shopId))`.
class ShopDetailScreen extends ConsumerWidget {
  const ShopDetailScreen({required this.shopId, super.key});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ShopModel> shopAsync = ref.watch(shopDetailProvider(shopId));

    return shopAsync.when(
      // Loading/Error dung rieng o day (khong qua AsyncValueWidget) vi can
      // 1 AppBar don gian (chi co nut back) trong luc CHUA co du lieu shop
      // de dua vao ShopDetailAppBar (can ten/trang thai tiem).
      loading: () => Scaffold(
        appBar: AppBar(iconTheme: const IconThemeData(color: AppColors.primary)),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(iconTheme: const IconThemeData(color: AppColors.primary)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error is Failure ? error.message : 'Không tải được thông tin tiệm.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular,
            ),
          ),
        ),
      ),
      data: (shop) => Scaffold(
        appBar: ShopDetailAppBar(shop: shop),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            ShopCoverImage(
              imageUrl: shop.coverImageUrl,
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.zero,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 20, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        shop.rating.toStringAsFixed(1),
                        style: AppTextStyles.titleMedium,
                      ),
                      Text(' / 5', style: AppTextStyles.bodySecondary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(icon: Icons.location_on_outlined, text: shop.address),
                  if (shop.phone != null) ...[
                    const SizedBox(height: 10),
                    _InfoRow(icon: Icons.phone_outlined, text: shop.phone!),
                  ],
                  if (shop.description != null && shop.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Giới thiệu', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 8),
                    Text(shop.description!, style: AppTextStyles.bodyRegular),
                  ],
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: 'Đặt lịch ngay',
                    onPressed: () {
                      ref.read(bookingDraftControllerProvider.notifier).start(shop.id);
                      context.push(RoutePaths.bookingSelectServiceStaff);
                    },
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodyRegular)),
      ],
    );
  }
}