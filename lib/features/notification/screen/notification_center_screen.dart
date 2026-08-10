import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/notification/model/notification_model.dart';
import 'package:barberbook_app/features/notification/provider/notification_provider.dart';
import 'package:barberbook_app/features/notification/widget/notification_list_item.dart';

/// Man goc cua tab "Thong bao" (US-NOTIFY-012 - Trung tam Thong bao trong
/// app). CHUA gom Push Notification qua Firebase - xem ghi chu pham vi
/// trong `README.md`.
class NotificationCenterScreen extends ConsumerWidget {
  const NotificationCenterScreen({super.key});

  Future<void> _handleTapNotification(WidgetRef ref, NotificationModel notification) async {
    if (notification.isRead) return;
    final Failure? failure = await ref.read(notificationRepositoryProvider).markAsRead(notification.id);
    if (failure == null) {
      ref.invalidate(notificationListProvider);
    }
    // Loi danh dau da doc khong quan trong den muc phai lam gian doan UX
    // bang SnackBar - bo qua im lang, nguoi dung van doc duoc noi dung binh
    // thuong, chi la trang thai "da doc" chua duoc luu.
  }

  Future<void> _handleMarkAllRead(BuildContext context, WidgetRef ref) async {
    final Failure? failure = await ref.read(notificationRepositoryProvider).markAllAsRead();
    if (!context.mounted) return;

    if (failure == null) {
      ref.invalidate(notificationListProvider);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<NotificationModel>> notificationsAsync = ref.watch(notificationListProvider);
    final int unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: BrandedAppBar(
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () => _handleMarkAllRead(context, ref),
              child: const Text('Đọc tất cả'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationListProvider),
        child: AsyncValueWidget<List<NotificationModel>>(
          value: notificationsAsync,
          skeletonItemCount: 4,
          isEmpty: (notifications) => notifications.isEmpty,
          emptyTitle: 'Chưa có thông báo nào',
          emptyDescription: 'Thông báo về lịch hẹn của bạn sẽ xuất hiện ở đây',
          onRetry: () => ref.invalidate(notificationListProvider),
          dataBuilder: (notifications) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final NotificationModel notification = notifications[index];
              return NotificationListItem(
                notification: notification,
                onTap: () => _handleTapNotification(ref, notification),
              );
            },
          ),
        ),
      ),
    );
  }
}