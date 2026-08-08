import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/booking/service/booking_service.dart';
import 'package:barberbook_app/shared/models/booking_model.dart';

abstract class BookingRepository {
  Future<Result<BookingModel>> createBooking({
    required String shopId,
    required String serviceId,
    String? staffId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
  });

  Future<Result<List<BookingWithDetails>>> fetchMyBookings();

  /// Tra ve `null` neu thanh cong, [Failure] neu that bai.
  Future<Failure?> cancelBooking(String bookingId);
}

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl(this._service);

  final BookingService _service;

  @override
  Future<Result<BookingModel>> createBooking({
    required String shopId,
    required String serviceId,
    String? staffId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
  }) async {
    try {
      final BookingModel booking = await _service.createBooking(
        shopId: shopId,
        serviceId: serviceId,
        staffId: staffId,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
      );
      return Success(booking);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<List<BookingWithDetails>>> fetchMyBookings() async {
    try {
      final List<BookingWithDetails> bookings = await _service.fetchMyBookings();
      return Success(bookings);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Failure?> cancelBooking(String bookingId) async {
    try {
      await _service.cancelBooking(bookingId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}