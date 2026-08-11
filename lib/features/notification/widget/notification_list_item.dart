import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/notification_type.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/features/notification/model/notification_model.dart';
class NotificationListItem extends StatelessWidget {
  const NotificationListItem({required this.notification, required this.onTap, super.key});

  final NotificationModel notification;
  final VoidCallback onTap;

  IconData get _icon => switch (notification.type) {
        NotificationType.booking => Icons.event_note_outlined,
        NotificationType.promotion => Icons.local_offer_outlined,
        NotificationType.general => Icons.notifications_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnread ? AppColors.surfaceElevated : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(_icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: AppTextStyles.bodySecondary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(Formatters.relativeTime(notification.createdAt), style: AppTextStyles.caption),
                ],
              ),
            ),
            if (isUnread) ...[
              const SizedBox(width: 8),
              Container(
                width: 9,
                height: 9,
                margin: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              ),
            ],
          ],
        ),
      ),
    );
  }
}