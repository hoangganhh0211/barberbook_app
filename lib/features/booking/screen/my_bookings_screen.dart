import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/booking/provider/booking_providers.dart';
import 'package:barberbook_app/features/booking/widget/booking_list_item.dart';
import 'package:barberbook_app/routes/route_paths.dart';

/// Man goc cua tab "Dat lich" (US-MYBOOKING-010) - 2 tab "Sap toi" (pending/
/// confirmed) va "Lich su" (completed/cancelled), phan loai theo `status`
/// (KHONG theo thoi gian) - vi Sprint 3 chua co co che tu dong chuyen
/// booking sang 'completed' khi qua gio (thuoc Partner Dashboard, Sprint 7).
class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  Future<void> _handleCancel(
    BuildContext context,
    WidgetRef ref,
    BookingWithDetails booking,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Huỷ lịch hẹn'),
        content: Text(
          'Bạn có chắc muốn huỷ lịch "${booking.service.name}" tại ${booking.shop.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Huỷ lịch', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final Failure? failure = await ref.read(bookingRepositoryProvider).cancelBooking(booking.id);

    if (!context.mounted) return;

    if (failure != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: AppColors.error));
    } else {
      ref.invalidate(myBookingsProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đã huỷ lịch hẹn')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<BookingWithDetails>> bookingsAsync = ref.watch(myBookingsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BrandedAppBar(
          bottom: const TabBar(
            tabs: [Tab(text: 'Sắp tới'), Tab(text: 'Lịch sử')],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: AsyncValueWidget<List<BookingWithDetails>>(
          value: bookingsAsync,
          skeletonItemCount: 3,
          isEmpty: (bookings) => bookings.isEmpty,
          emptyTitle: 'Chưa có lịch hẹn nào',
          emptyDescription: 'Đặt lịch cắt tóc đầu tiên của bạn ngay',
          emptyCtaLabel: 'Tìm tiệm ngay',
          onEmptyCtaPressed: () => context.go(RoutePaths.customerShops),
          onRetry: () => ref.invalidate(myBookingsProvider),
          dataBuilder: (bookings) {
            final List<BookingWithDetails> upcoming = bookings
                .where((b) => b.status == BookingStatus.pending || b.status == BookingStatus.confirmed)
                .toList();
            final List<BookingWithDetails> history = bookings
                .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
                .toList();

            return TabBarView(
              children: [
                _BookingTabList(
                  bookings: upcoming,
                  emptyText: 'Không có lịch hẹn sắp tới',
                  onCancel: (booking) => _handleCancel(context, ref, booking),
                ),
                _BookingTabList(bookings: history, emptyText: 'Chưa có lịch sử đặt lịch'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BookingTabList extends StatelessWidget {
  const _BookingTabList({required this.bookings, required this.emptyText, this.onCancel});

  final List<BookingWithDetails> bookings;
  final String emptyText;

  /// `null` = khong cho huy (dung cho tab "Lich su").
  final void Function(BookingWithDetails booking)? onCancel;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(title: emptyText);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final BookingWithDetails booking = bookings[index];
        return BookingListItem(
          booking: booking,
          onCancel: onCancel != null && booking.status.canCancel ? () => onCancel!(booking) : null,
        );
      },
    );
  }
}