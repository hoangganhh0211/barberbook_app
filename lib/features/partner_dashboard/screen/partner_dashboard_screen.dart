import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/utils/vietnam_time.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/core/widgets/error_state_widget.dart';
import 'package:barberbook_app/core/widgets/skeleton_loading.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/partner_dashboard/provider/partner_dashboard_provider.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/staff_management/provider/staff_management_provider.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

class PartnerDashboardScreen extends ConsumerWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopAsync = ref.watch(myOwnedShopProvider);

    return Scaffold(
      appBar: BrandedAppBar(
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            onPressed: () {
              final String? shopId = ref.read(myOwnedShopProvider).valueOrNull?.id;
              ref.invalidate(myOwnedShopProvider);
              if (shopId != null) {
                ref.invalidate(partnerDashboardBookingsProvider(shopId));
                ref.invalidate(shopStaffListProvider(shopId));
              }
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: shopAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ErrorStateWidget(
          message: error is Failure ? error.message : 'Đã có lỗi xảy ra.',
          onRetry: () => ref.invalidate(myOwnedShopProvider),
        ),
        data: (shop) {
          if (shop == null) {
            return const EmptyStateWidget(
              icon: Icons.storefront_outlined,
              title: 'Chưa có tiệm tóc',
              description: 'Tài khoản hiện tại chưa được liên kết với tiệm tóc nào.',
            );
          }
          return _PartnerDashboardContent(shop: shop);
        },
      ),
    );
  }
}

class _PartnerDashboardContent extends ConsumerWidget {
  const _PartnerDashboardContent({required this.shop});

  final ShopModel shop;

  Future<void> _handleConfirmBooking(
    BuildContext context,
    WidgetRef ref,
    BookingWithDetails booking,
  ) async {
    final bool? shouldConfirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận lịch hẹn'),
        content: Text(
          'Xác nhận lịch ${booking.service.name} của '
          '${booking.customerName.isNotEmpty ? booking.customerName : 'khách hàng'} '
          'vào ${Formatters.dateTimeVietnam(booking.startTime)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Để sau'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
    if (shouldConfirm != true || !context.mounted) return;

    final Failure? failure = await ref
        .read(partnerDashboardRepositoryProvider)
        .confirmBooking(booking.id);
    if (!context.mounted) return;

    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
        );
      return;
    }

    ref.invalidate(partnerDashboardBookingsProvider(shop.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Đã xác nhận lịch hẹn. Khách hàng sẽ nhận được thông báo.'),
          backgroundColor: AppColors.success,
        ),
      );
  }

  Future<void> _handleCompleteBooking(
    BuildContext context,
    WidgetRef ref,
    BookingWithDetails booking,
  ) async {
    final bool? shouldComplete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận hoàn thành dịch vụ'),
        content: Text(
          'Đánh dấu dịch vụ ${booking.service.name} của '
          '${booking.customerName.isNotEmpty ? booking.customerName : 'khách hàng'} '
          'là đã hoàn thành? Khách hàng sẽ nhận được thông báo và có thể đánh giá.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Để sau'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.task_alt_rounded),
            label: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
    if (shouldComplete != true || !context.mounted) return;

    final Failure? failure = await ref
        .read(partnerDashboardRepositoryProvider)
        .completeBooking(booking.id);
    if (!context.mounted) return;

    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
        );
      return;
    }

    ref.invalidate(partnerDashboardBookingsProvider(shop.id));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Đã cập nhật lịch hẹn sang Hoàn tất.'),
          backgroundColor: AppColors.success,
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(partnerDashboardBookingsProvider(shop.id));
    final staffAsync = ref.watch(shopStaffListProvider(shop.id));

    return bookingsAsync.when(
      loading: () => const SkeletonLoading(itemCount: 4),
      error: (error, stackTrace) => ErrorStateWidget(
        message: error is Failure ? error.message : 'Đã có lỗi xảy ra.',
        onRetry: () {
          ref.invalidate(partnerDashboardBookingsProvider(shop.id));
          ref.invalidate(shopStaffListProvider(shop.id));
        },
      ),
      data: (bookings) => staffAsync.when(
        loading: () => const SkeletonLoading(itemCount: 4),
        error: (error, stackTrace) => ErrorStateWidget(
          message: error is Failure ? error.message : 'Đã có lỗi xảy ra.',
          onRetry: () => ref.invalidate(shopStaffListProvider(shop.id)),
        ),
        data: (staff) => _DashboardBody(
          shop: shop,
          bookings: bookings,
          staff: staff,
          onConfirmBooking: (booking) => _handleConfirmBooking(context, ref, booking),
          onCompleteBooking: (booking) => _handleCompleteBooking(context, ref, booking),
          onRefresh: () async {
            try {
              await ref.refresh(partnerDashboardBookingsProvider(shop.id).future);
            } catch (_) {}
            try {
              await ref.refresh(shopStaffListProvider(shop.id).future);
            } catch (_) {}
          },
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.shop,
    required this.bookings,
    required this.staff,
    required this.onRefresh,
    required this.onConfirmBooking,
    required this.onCompleteBooking,
  });

  final ShopModel shop;
  final List<BookingWithDetails> bookings;
  final List<StaffModel> staff;
  final Future<void> Function() onRefresh;
  final Future<void> Function(BookingWithDetails booking) onConfirmBooking;
  final Future<void> Function(BookingWithDetails booking) onCompleteBooking;

  @override
  Widget build(BuildContext context) {
    // Keep appointment comparisons as absolute instants. Only the boundaries
    // are derived from the shop's Vietnam calendar, not the device timezone.
    final DateTime nowUtc = VietnamTime.nowUtc();
    final DateTime nowVietnamWall = VietnamTime.toWall(nowUtc);
    final DateTime todayStartUtc = VietnamTime.startOfDayUtc(nowVietnamWall);
    final DateTime tomorrowStartUtc = todayStartUtc.add(const Duration(days: 1));
    final DateTime monthStartUtc =
        VietnamTime.startOfMonthUtc(nowVietnamWall.year, nowVietnamWall.month);
    final DateTime nextMonthStartUtc = nowVietnamWall.month == 12
        ? VietnamTime.startOfMonthUtc(nowVietnamWall.year + 1, 1)
        : VietnamTime.startOfMonthUtc(nowVietnamWall.year, nowVietnamWall.month + 1);

    final int todayBookingCount = bookings.where((booking) {
      final DateTime startTime = booking.startTime.toUtc();
      return !startTime.isBefore(todayStartUtc) &&
          startTime.isBefore(tomorrowStartUtc) &&
          booking.status != BookingStatus.cancelled;
    }).length;
    final int pendingBookingCount =
        bookings.where((booking) => booking.status == BookingStatus.pending).length;
    final double monthlyRevenue = bookings
        .where((booking) {
          final DateTime startTime = booking.startTime.toUtc();
          return booking.status == BookingStatus.completed &&
              !startTime.isBefore(monthStartUtc) &&
              startTime.isBefore(nextMonthStartUtc);
        })
        .fold<double>(0, (total, booking) => total + booking.totalPrice);
    final int activeStaffCount = staff.where((member) => member.isActive).length;
    final List<BookingWithDetails> bookingsToComplete = bookings
        .where((booking) =>
            booking.status == BookingStatus.confirmed &&
            !booking.endTime.toUtc().isAfter(nowUtc))
        .toList()
      ..sort((a, b) => b.startTime.toUtc().compareTo(a.startTime.toUtc()));
    final List<BookingWithDetails> upcomingBookings = bookings
        .where((booking) =>
            (booking.status == BookingStatus.pending ||
                booking.status == BookingStatus.confirmed) &&
            !booking.startTime.toUtc().isBefore(nowUtc))
        .toList()
      ..sort((a, b) => a.startTime.toUtc().compareTo(b.startTime.toUtc()));
    // Ưu tiên hiển thị mọi lịch đang chờ để chủ tiệm không bỏ lỡ nút xác nhận;
    // phần còn lại lấy tối đa 5 lịch đã xác nhận gần nhất.
    final List<BookingWithDetails> pendingUpcomingBookings = upcomingBookings
        .where((booking) => booking.status == BookingStatus.pending)
        .toList();
    final List<BookingWithDetails> confirmedUpcomingBookings = upcomingBookings
        .where((booking) => booking.status == BookingStatus.confirmed)
        .toList();
    final List<BookingWithDetails> visibleBookings = <BookingWithDetails>[
      ...pendingUpcomingBookings,
      ...confirmedUpcomingBookings.take(
        pendingUpcomingBookings.length < 5 ? 5 - pendingUpcomingBookings.length : 0,
      ),
    ]..sort((a, b) => a.startTime.toUtc().compareTo(b.startTime.toUtc()));

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text('Tổng quan', style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text(Formatters.dateVietnam(nowUtc), style: AppTextStyles.bodySecondary),
          const SizedBox(height: 16),
          _ShopSummaryCard(shop: shop),
          const SizedBox(height: 24),
          Text('Chỉ số chính', style: AppTextStyles.heading2),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.32,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _KpiCard(
                icon: Icons.calendar_today_rounded,
                title: 'Lịch hẹn hôm nay',
                value: '$todayBookingCount',
                accent: AppColors.primary,
              ),
              _KpiCard(
                icon: Icons.hourglass_top_rounded,
                title: 'Chờ xác nhận',
                value: '$pendingBookingCount',
                accent: AppColors.warning,
              ),
              _KpiCard(
                icon: Icons.payments_outlined,
                title: 'Doanh thu tháng này',
                value: Formatters.currency(monthlyRevenue),
                accent: AppColors.success,
              ),
              _KpiCard(
                icon: Icons.groups_rounded,
                title: 'Thợ đang hoạt động',
                value: '$activeStaffCount',
                accent: AppColors.info,
              ),
            ],
          ),
          if (bookingsToComplete.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Text('Lịch cần hoàn tất', style: AppTextStyles.heading2)),
                Text('${bookingsToComplete.length} lịch', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 12),
            for (final booking in bookingsToComplete) ...[
              _UpcomingBookingCard(
                booking: booking,
                onComplete: () => onCompleteBooking(booking),
              ),
              const SizedBox(height: 10),
            ],
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Text('Lịch hẹn sắp tới', style: AppTextStyles.heading2)),
              Text('${visibleBookings.length} lịch', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 12),
          if (visibleBookings.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Icon(Icons.event_available_outlined, size: 36, color: AppColors.textDisabled),
                  SizedBox(height: 8),
                  Text('Chưa có lịch hẹn sắp tới', style: AppTextStyles.titleMedium),
                  SizedBox(height: 4),
                  Text(
                    'Các lịch hẹn mới sẽ hiển thị tại đây.',
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            for (final booking in visibleBookings) ...[
              _UpcomingBookingCard(
                booking: booking,
                onConfirm: booking.status == BookingStatus.pending
                    ? () => onConfirmBooking(booking)
                    : null,
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _ShopSummaryCard extends StatelessWidget {
  const _ShopSummaryCard({required this.shop});

  final ShopModel shop;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = shop.isOpen ? AppColors.success : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  shop.address,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: statusColor),
                        const SizedBox(width: 5),
                        Text(
                          shop.isOpen ? 'Đang mở cửa' : 'Đang đóng cửa',
                          style: AppTextStyles.caption.copyWith(color: statusColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
                        const SizedBox(width: 3),
                        Text(shop.rating.toStringAsFixed(1), style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 19),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: AppTextStyles.heading2),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _UpcomingBookingCard extends StatelessWidget {
  const _UpcomingBookingCard({required this.booking, this.onConfirm, this.onComplete});

  final BookingWithDetails booking;
  final VoidCallback? onConfirm;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = switch (booking.status) {
      BookingStatus.pending => AppColors.warning,
      BookingStatus.confirmed => AppColors.info,
      BookingStatus.completed => AppColors.success,
      BookingStatus.cancelled => AppColors.error,
    };
    final DateTime startTime = booking.startTime;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.content_cut_rounded, color: AppColors.primary, size: 21),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.service.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (booking.customerName.isNotEmpty)
                      Text(
                        booking.customerName,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.dateVietnam(startTime)} · ${Formatters.timeVietnam(startTime)}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${Formatters.duration(booking.service.durationMinutes)} · ${Formatters.currency(booking.totalPrice)}',
                      style: AppTextStyles.bodySecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status.label,
                  style: AppTextStyles.caption.copyWith(color: statusColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (onConfirm != null || onComplete != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: onComplete != null
                  ? FilledButton.icon(
                      onPressed: onComplete,
                      icon: const Icon(Icons.task_alt_rounded, size: 18),
                      label: const Text('Hoàn thành dịch vụ'),
                    )
                  : FilledButton.icon(
                      onPressed: onConfirm,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Xác nhận lịch'),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
