import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';

class StaffScheduleItem extends StatefulWidget {
  const StaffScheduleItem({
    required this.booking,
    this.onComplete,
    super.key,
  });

  final BookingWithDetails booking;
  final Future<void> Function(BookingWithDetails booking)? onComplete;

  @override
  State<StaffScheduleItem> createState() => _StaffScheduleItemState();
}

class _StaffScheduleItemState extends State<StaffScheduleItem> {
  bool _isCompleting = false;

  Color get _statusColor => switch (widget.booking.status) {
        BookingStatus.pending => AppColors.warning,
        BookingStatus.confirmed => AppColors.info,
        BookingStatus.completed => AppColors.success,
        BookingStatus.cancelled => AppColors.textDisabled,
      };

  Future<void> _complete() async {
    final callback = widget.onComplete;
    if (callback == null || _isCompleting) return;

    setState(() => _isCompleting = true);
    try {
      await callback(widget.booking);
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;

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
              Column(
                children: [
                  Text(Formatters.time(booking.startTime.toLocal()), style: AppTextStyles.titleMedium),
                  Text(Formatters.time(booking.endTime.toLocal()), style: AppTextStyles.caption),
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
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.status.label,
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (booking.status == BookingStatus.confirmed && widget.onComplete != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isCompleting ? null : _complete,
                icon: _isCompleting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.task_alt_rounded, size: 18),
                label: const Text('Hoàn thành dịch vụ'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
