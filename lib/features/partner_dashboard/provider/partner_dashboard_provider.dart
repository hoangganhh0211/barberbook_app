import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/partner_dashboard/repository/partner_dashboard_repository.dart';
import 'package:barberbook_app/features/partner_dashboard/service/partner_dashboard_service.dart';

final partnerDashboardServiceProvider = Provider<PartnerDashboardService>((ref) {
  return PartnerDashboardService(ref.watch(supabaseClientProvider));
});

final partnerDashboardRepositoryProvider = Provider<PartnerDashboardRepository>((ref) {
  return PartnerDashboardRepositoryImpl(ref.watch(partnerDashboardServiceProvider));
});

final partnerDashboardBookingsProvider =
    FutureProvider.family<List<BookingWithDetails>, String>((ref, shopId) async {
  final result = await ref.watch(partnerDashboardRepositoryProvider).fetchShopBookings(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
