import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/features/booking/provider/booking_catalog_providers.dart';
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/features/booking/widget/selectable_option_card.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

/// Man Buoc 1-2 cua luong Dat lich (US-BOOKING-009): chon Dich vu (bat
/// buoc) + chon Tho (tuy chon, mac dinh "Bat ky tho nao"). Doc `shopId` tu
/// [BookingDraftController] (da duoc [ShopDetailScreen] khoi tao qua
/// `start()` truoc khi push sang man nay).
class BookingServiceStaffScreen extends ConsumerWidget {
  const BookingServiceStaffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final BookingDraft? draft = ref.watch(bookingDraftControllerProvider);

    // Phong ve: neu vi ly do nao do vao thang man nay ma chua co draft (vd:
    // hot reload giua chung khi dev, hoac dieu huong sai) - bao loi ro rang
    // thay vi de app crash vi truy cap `draft.shopId` tren gia tri null.
    if (draft == null) {
      return Scaffold(
        appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
        body: const Center(child: Text('Vui lòng bắt đầu đặt lịch từ trang Chi tiết Tiệm.')),
      );
    }

    final AsyncValue<List<ServiceModel>> servicesAsync = ref.watch(serviceListProvider(draft.shopId));
    final AsyncValue<List<StaffModel>> staffAsync = ref.watch(staffListProvider(draft.shopId));
    final BookingDraftController controller = ref.read(bookingDraftControllerProvider.notifier);

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Chọn dịch vụ', style: AppTextStyles.heading2),
          const SizedBox(height: 12),
          AsyncValueWidget<List<ServiceModel>>(
            value: servicesAsync,
            skeletonItemCount: 3,
            isEmpty: (services) => services.isEmpty,
            emptyTitle: 'Tiệm chưa có dịch vụ nào',
            onRetry: () => ref.invalidate(serviceListProvider(draft.shopId)),
            dataBuilder: (services) => Column(
              children: [
                for (final service in services) ...[
                  SelectableOptionCard(
                    title: service.name,
                    subtitle:
                        '${Formatters.duration(service.durationMinutes)} · ${Formatters.currency(service.price)}',
                    isSelected: draft.selectedService?.id == service.id,
                    onTap: () => controller.selectService(service),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Chọn thợ', style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text(
            'Không bắt buộc - để trống nếu bạn không có yêu cầu riêng',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 12),
          SelectableOptionCard(
            title: 'Bất kỳ thợ nào',
            leading: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.shuffle, color: AppColors.textSecondary),
            ),
            isSelected: draft.selectedStaff == null,
            onTap: () => controller.selectStaff(null),
          ),
          const SizedBox(height: 10),
          AsyncValueWidget<List<StaffModel>>(
            value: staffAsync,
            skeletonItemCount: 2,
            onRetry: () => ref.invalidate(staffListProvider(draft.shopId)),
            dataBuilder: (staffList) => Column(
              children: [
                for (final staff in staffList) ...[
                  SelectableOptionCard(
                    title: staff.fullName,
                    subtitle: staff.bio,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.background,
                      backgroundImage:
                          staff.avatarUrl != null ? CachedNetworkImageProvider(staff.avatarUrl!) : null,
                      child: staff.avatarUrl == null
                          ? const Icon(Icons.person_outline, color: AppColors.textSecondary)
                          : null,
                    ),
                    isSelected: draft.selectedStaff?.id == staff.id,
                    onTap: () => controller.selectStaff(staff),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Tiếp tục',
            onPressed: draft.canContinueToDateTime
                ? () => context.push(RoutePaths.bookingSelectDateTime)
                : null,
          ),
        ],
      ),
    );
  }
}