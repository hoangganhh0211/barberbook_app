import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/notification/model/notification_model.dart';
import 'package:barberbook_app/features/notification/repository/notification_repository.dart';
import 'package:barberbook_app/features/notification/service/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(supabaseClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationServiceProvider));
});
final notificationListProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final result = await ref.watch(notificationRepositoryProvider).fetchMyNotifications();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
final unreadNotificationCountProvider = Provider<int>((ref) {
  final AsyncValue<List<NotificationModel>> notificationsAsync = ref.watch(notificationListProvider);
  return notificationsAsync.maybeWhen(
    data: (notifications) => notifications.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});