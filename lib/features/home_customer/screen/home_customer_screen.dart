import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/home_customer/widget/featured_shop_card.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Man goc cua tab "Home" (US-HOME-013 - ban rut gon Sprint 2: loi chao +
/// section Tiem noi bat, dung LAI `shopListProvider` da co tu Chuc nang 1/2,
/// KHONG tao provider rieng - tranh 2 nguon du lieu Tiem khac nhau).
class HomeCustomerScreen extends ConsumerWidget {
  const HomeCustomerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String greetingName = switch (authState) {
      AuthAuthenticated(:final session) => session.fullName,
      _ => 'bạn',
    };

    final AsyncValue<List<ShopModel>> shopsAsync = ref.watch(shopListProvider(''));

    return Scaffold(
      appBar: const BrandedAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(shopListProvider('')),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Xin chào, $greetingName 👋', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(
              'Hôm nay bạn muốn đặt lịch cắt tóc ở đâu?',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tiệm nổi bật', style: AppTextStyles.titleMedium),
                TextButton(
                  // Dieu huong sang tab "Tiem" trong cung 1 Shell. Dung
                  // `context.go` (khong phai `navigationShell.goBranch`) vi
                  // man nay khong co san tham chieu toi navigationShell -
                  // don gian hoa, chap nhan danh doi khong giu scroll cua
                  // tab dich (khong dang ke voi UX o day).
                  onPressed: () => context.go(RoutePaths.customerShops),
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 190,
              child: AsyncValueWidget<List<ShopModel>>(
                value: shopsAsync,
                skeletonItemCount: 1,
                isEmpty: (shops) => shops.isEmpty,
                emptyTitle: 'Chưa có tiệm nào',
                onRetry: () => ref.invalidate(shopListProvider('')),
                dataBuilder: (shops) => ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: shops.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => FeaturedShopCard(
                    shop: shops[index],
                    onTap: () => context.push(RoutePaths.customerShopDetail(shops[index].id)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}