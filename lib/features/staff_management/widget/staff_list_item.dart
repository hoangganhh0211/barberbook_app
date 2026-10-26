import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

class StaffListItem extends StatelessWidget {
  const StaffListItem({required this.staff, required this.onTap, super.key});

  final StaffModel staff;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isLinked = staff.profileId != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        // Lam mo tho tam ngung de phan biet nhanh voi tho dang hoat dong.
        opacity: staff.isActive ? 1 : 0.55,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.background,
                backgroundImage:
                    staff.avatarUrl != null ? CachedNetworkImageProvider(staff.avatarUrl!) : null,
                child: staff.avatarUrl == null
                    ? const Icon(Icons.person_outline, color: AppColors.textSecondary)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.fullName,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (staff.bio != null && staff.bio!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        staff.bio!,
                        style: AppTextStyles.bodySecondary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _Chip(
                          label: isLinked ? 'Đã gán tài khoản' : 'Chưa gán tài khoản',
                          color: isLinked ? AppColors.success : AppColors.warning,
                        ),
                        if (!staff.isActive)
                          const _Chip(label: 'Tạm ngưng', color: AppColors.textDisabled),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}