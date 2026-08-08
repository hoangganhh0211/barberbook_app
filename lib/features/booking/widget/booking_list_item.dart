import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_cover_image.dart';

/// 1 dong trong danh sach Lich hen (tab "Dat lich"). Tai su dung
/// [ShopCoverImage] (feature khac) - chap nhan phu thuoc cheo feature vi
/// day la widget hien thi thuan tuy, khong keo theo logic nghiep vu.
class BookingListItem extends StatelessWidget {
  const BookingListItem({required this.booking, this.onCancel, super.key});

  final BookingWithDetails booking;

  /// `null` = khong hien nut Huy (dung cho tab "Lich su" - booking da
  /// completed/cancelled thi khong the huy them).
  final VoidCallback? onCancel;

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopCoverImage(imageUrl: booking.shop.coverImageUrl, width: 56, height: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.shop.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.service.name,
                      style: AppTextStyles.bodySecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _BookingStatusChip(status: booking.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(Formatters.dateTime(booking.startTime), style: AppTextStyles.bodySecondary),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(Formatters.currency(booking.totalPrice), style: AppTextStyles.bodySecondary),
            ],
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: const Text('Huỷ lịch'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BookingStatusChip extends StatelessWidget {
  const _BookingStatusChip({required this.status});

  final BookingStatus status;

  Color get _color => switch (status) {
        BookingStatus.pending => AppColors.warning,
        BookingStatus.confirmed => AppColors.info,
        BookingStatus.completed => AppColors.success,
        BookingStatus.cancelled => AppColors.textDisabled,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(color: _color, fontWeight: FontWeight.w600),
      ),
    );
  }
}