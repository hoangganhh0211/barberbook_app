import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/partner_dashboard/repository/partner_dashboard_repository.dart';
import 'package:barberbook_app/features/partner_dashboard/service/partner_dashboard_service.dart';

final partnerDashboardServiceProvider = Provider<PartnerDashboardService>((ref) {
  return PartnerDashboardService(ref.watch(supabaseClientProvider));
});

final partnerDashboardRepositoryProvider = Provider<PartnerDashboardRepository>((ref) {
  return PartnerDashboardRepositoryImpl(ref.watch(partnerDashboardServiceProvider));
});

final partnerBookingRealtimeProvider = StreamProvider.family<int, String>((ref, shopId) {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const Stream<int>.empty();

  final client = ref.watch(supabaseClientProvider);
  final controller = StreamController<int>();
  var eventSequence = 0;
  final channel = client
      .channel('partner-bookings-$userId-$shopId')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'bookings',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'shop_id',
          value: shopId,
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

final partnerDashboardBookingsProvider =
    FutureProvider.family<List<BookingWithDetails>, String>((ref, shopId) async {
  ref.watch(partnerBookingRealtimeProvider(shopId));
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return const <BookingWithDetails>[];

  final result = await ref.watch(partnerDashboardRepositoryProvider).fetchShopBookings(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
