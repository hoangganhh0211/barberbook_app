import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/leave_request_status.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';


class LeaveRequestListItem extends StatelessWidget {
  const LeaveRequestListItem({
    required this.request,
    this.showStaffName = false,
    this.trailing,
    super.key,
  });

  final LeaveRequestModel request;

  final bool showStaffName;


  final Widget? trailing;

  Color get _color => switch (request.status) {
        LeaveRequestStatus.pending => AppColors.warning,
        LeaveRequestStatus.approved => AppColors.success,
        LeaveRequestStatus.rejected => AppColors.error,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showStaffName) ...[
                      Text(
                        request.staffName.isEmpty ? 'Nhân viên' : request.staffName,
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      '${Formatters.date(request.startDate)} - ${Formatters.date(request.endDate)}',
                      style: showStaffName ? AppTextStyles.bodySecondary : AppTextStyles.titleMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  request.status.label,
                  style: AppTextStyles.caption.copyWith(color: _color, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          if (request.reason != null && request.reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(request.reason!, style: AppTextStyles.bodyRegular),
          ],
          if (trailing != null) ...[
            const SizedBox(height: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}