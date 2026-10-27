import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/partner_dashboard/service/partner_dashboard_service.dart';

abstract class PartnerDashboardRepository {
  Future<Result<List<BookingWithDetails>>> fetchShopBookings(String shopId);

  Future<Failure?> confirmBooking(String bookingId);

  Future<Failure?> completeBooking(String bookingId);
}

class PartnerDashboardRepositoryImpl implements PartnerDashboardRepository {
  PartnerDashboardRepositoryImpl(this._service);

  final PartnerDashboardService _service;

  @override
  Future<Failure?> confirmBooking(String bookingId) async {
    try {
      await _service.confirmBooking(bookingId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure(
        'Không thể xác nhận lịch hẹn. Vui lòng kiểm tra kết nối và thử lại.',
      );
    }
  }

  @override
  Future<Failure?> completeBooking(String bookingId) async {
    try {
      await _service.completeBooking(bookingId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure(
        'Không thể xác nhận hoàn thành dịch vụ. Vui lòng kiểm tra kết nối và thử lại.',
      );
    }
  }

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
