import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/booking/repository/booking_repository.dart';
import 'package:barberbook_app/features/booking/service/booking_service.dart';

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService(ref.watch(supabaseClientProvider));
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(ref.watch(bookingServiceProvider));
});

/// Danh sach lich hen cua khach dang dang nhap - dung o tab "Dat lich"
/// (Chuc nang 4). Goi `ref.invalidate(myBookingsProvider)` sau khi tao moi
/// hoac huy 1 booking de lam moi danh sach.
final myBookingsProvider = FutureProvider<List<BookingWithDetails>>((ref) async {
  final result = await ref.watch(bookingRepositoryProvider).fetchMyBookings();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});