import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/features/booking/provider/booking_providers.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Man Buoc 4 (cuoi cung) cua luong Dat lich: xem lai thong tin da chon va
/// xac nhan tao booking that trong Supabase.
class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key});

  @override
  ConsumerState<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  bool _isSubmitting = false;

  Future<void> _handleConfirm(BookingDraft draft) async {
    setState(() => _isSubmitting = true);

    final DateTime startTime = draft.selectedDateTime!;
    final DateTime endTime = startTime.add(Duration(minutes: draft.selectedService!.durationMinutes));

    final result = await ref.read(bookingRepositoryProvider).createBooking(
          shopId: draft.shopId,
          serviceId: draft.selectedService!.id,
          staffId: draft.selectedStaff?.id,
          startTime: startTime,
          endTime: endTime,
          totalPrice: draft.selectedService!.price,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (result) {
      case Success():
        // Dat lich thanh cong - don dep draft NGAY de khong anh huong lan
        // dat lich tiep theo, roi ve Home (tab "Dat lich" se hien lich hen
        // nay khi Chuc nang 4 hoan thanh).
        ref.read(bookingDraftControllerProvider.notifier).reset();
        ref.invalidate(myBookingsProvider);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Đặt lịch thành công!'), backgroundColor: AppColors.success),
          );
        context.go(RoutePaths.customerHome);
      case ResultFailure(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookingDraft? draft = ref.watch(bookingDraftControllerProvider);

    if (draft == null || !draft.canConfirm) {
      return Scaffold(
        appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
        body: const Center(child: Text('Vui lòng hoàn tất các bước trước đó.')),
      );
    }

    final AsyncValue<ShopModel> shopAsync = ref.watch(shopDetailProvider(draft.shopId));

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Xác nhận đặt lịch', style: AppTextStyles.heading2),
          const SizedBox(height: 20),
          _SummaryCard(
            children: [
              _SummaryRow(
                icon: Icons.storefront_outlined,
                label: 'Tiệm',
                value: shopAsync.when(
                  data: (shop) => shop.name,
                  loading: () => 'Đang tải...',
                  error: (_, __) => '—',
                ),
              ),
              _SummaryRow(
                icon: Icons.content_cut,
                label: 'Dịch vụ',
                value: draft.selectedService!.name,
              ),
              _SummaryRow(
                icon: Icons.person_outline,
                label: 'Thợ',
                value: draft.selectedStaff?.fullName ?? 'Bất kỳ thợ nào',
              ),
              _SummaryRow(
                icon: Icons.calendar_today_outlined,
                label: 'Thời gian',
                value: Formatters.dateTime(draft.selectedDateTime!),
              ),
              _SummaryRow(
                icon: Icons.timer_outlined,
                label: 'Thời lượng',
                value: Formatters.duration(draft.selectedService!.durationMinutes),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SummaryCard(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng cộng', style: AppTextStyles.titleMedium),
                  Text(
                    Formatters.currency(draft.selectedService!.price),
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          AppPrimaryButton(
            label: 'Xác nhận đặt lịch',
            isLoading: _isSubmitting,
            onPressed: () => _handleConfirm(draft),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.bodyRegular),
            ],
          ),
        ),
      ],
    );
  }
}