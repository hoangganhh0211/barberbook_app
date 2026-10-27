import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/booking/repository/booking_repository.dart';
import 'package:barberbook_app/features/booking/service/booking_service.dart';
import 'package:barberbook_app/features/notification/provider/notification_provider.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService(ref.watch(supabaseClientProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(ref.watch(bookingServiceProvider));
});
final customerBookingRealtimeProvider = StreamProvider<int>((ref) {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const Stream<int>.empty();

  final client = ref.watch(supabaseClientProvider);
  final controller = StreamController<int>();
  var eventSequence = 0;
  final channel = client
      .channel('customer-bookings-$userId')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'bookings',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'customer_id',
          value: userId,
        ),
        callback: (_) {
          if (!controller.isClosed) {
            controller.add(++eventSequence);
          }
          ref.invalidate(notificationListProvider);
        },
      )
      .subscribe();

  ref.onDispose(() {
    unawaited(client.removeChannel(channel).then<void>((_) {}));
    unawaited(controller.close());
  });

  return controller.stream;
});

final FutureProvider<List<BookingWithDetails>> myBookingsProvider =
    FutureProvider<List<BookingWithDetails>>((ref) async {
  // Mỗi sự kiện Realtime khiến provider này tải danh sách mới.
  ref.watch(customerBookingRealtimeProvider);
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const <BookingWithDetails>[];

  final result = await ref.watch(bookingRepositoryProvider).fetchMyBookings();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
