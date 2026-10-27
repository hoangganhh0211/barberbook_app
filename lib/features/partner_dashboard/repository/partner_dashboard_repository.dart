import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/partner_dashboard/service/partner_dashboard_service.dart';

abstract class PartnerDashboardRepository {
  Future<Result<List<BookingWithDetails>>> fetchShopBookings(String shopId);
}

class PartnerDashboardRepositoryImpl implements PartnerDashboardRepository {
  PartnerDashboardRepositoryImpl(this._service);

  final PartnerDashboardService _service;

  @override
  Future<Result<List<BookingWithDetails>>> fetchShopBookings(String shopId) async {
    try {
      final List<BookingWithDetails> bookings = await _service.fetchShopBookings(shopId);
      return Success(bookings);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(
        NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'),
      );
    }
  }
}
