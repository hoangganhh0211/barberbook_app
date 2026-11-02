import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/notification/model/notification_model.dart';
import 'package:barberbook_app/features/notification/repository/notification_repository.dart';
import 'package:barberbook_app/features/notification/service/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref.watch(supabaseClientProvider));
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(notificationServiceProvider));
});

final notificationRealtimeProvider = StreamProvider<int>((ref) {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const Stream<int>.empty();

  final SupabaseClient client = ref.watch(supabaseClientProvider);
  final StreamController<int> controller = StreamController<int>();
  int eventSequence = 0;
  final RealtimeChannel channel = client
      .channel('customer-notifications-$userId')
      .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notifications',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'customer_id',
          value: userId,
        ),
        callback: (_) {
          if (!controller.isClosed) {
            controller.add(++eventSequence);
          }
        },
      )
      .subscribe();

  ref.onDispose(() {
    unawaited(client.removeChannel(channel).then<void>((_) {}));
    unawaited(controller.close());
  });

  return controller.stream;
});

final notificationListProvider = FutureProvider<List<NotificationModel>>((ref) async {
  ref.watch(notificationRealtimeProvider);

  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const <NotificationModel>[];

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
