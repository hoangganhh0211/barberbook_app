import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/staff_schedule/service/staff_schedule_service.dart';

abstract class StaffScheduleRepository {
  Future<Result<String?>> fetchMyStaffId();

  Future<Result<({String id, String shopId})?>> fetchMyStaffInfo();

  Future<Failure?> completeBooking(String bookingId);

  Future<Result<List<BookingWithDetails>>> fetchMySchedule({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  });
}

class StaffScheduleRepositoryImpl implements StaffScheduleRepository {
  StaffScheduleRepositoryImpl(this._service);

  final StaffScheduleService _service;

  @override
  Future<Result<String?>> fetchMyStaffId() async {
    try {
      final String? staffId = await _service.fetchMyStaffId();
      return Success(staffId);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<({String id, String shopId})?>> fetchMyStaffInfo() async {
    try {
      final info = await _service.fetchMyStaffInfo();
      return Success(info);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
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
  Future<Result<List<BookingWithDetails>>> fetchMySchedule({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) async {
    try {
      final List<BookingWithDetails> schedule = await _service.fetchMySchedule(
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );
      return Success(schedule);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }
}