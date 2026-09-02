import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';

class StaffScheduleItem extends StatelessWidget {
  const StaffScheduleItem({required this.booking, super.key});

  final BookingWithDetails booking;

  Color get _statusColor => switch (booking.status) {
        BookingStatus.pending => AppColors.warning,
        BookingStatus.confirmed => AppColors.info,
        BookingStatus.completed => AppColors.success,
        BookingStatus.cancelled => AppColors.textDisabled,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(Formatters.time(booking.startTime), style: AppTextStyles.titleMedium),
              Text(Formatters.time(booking.endTime), style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(width: 14),
          Container(width: 1, height: 40, color: AppColors.border),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.customerName.isEmpty ? 'Khách hàng' : booking.customerName,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              booking.status.label,
              style: AppTextStyles.caption.copyWith(color: _statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}