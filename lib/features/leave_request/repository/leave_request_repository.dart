import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';
import 'package:barberbook_app/features/leave_request/service/leave_request_service.dart';

abstract class LeaveRequestRepository {
  Future<Result<LeaveRequestModel>> createLeaveRequest({
    required String shopId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  });

  Future<Result<List<LeaveRequestModel>>> fetchMyLeaveRequests();

  Future<Result<List<LeaveRequestModel>>> fetchAllLeaveRequests();

  Future<Failure?> reviewLeaveRequest({required String requestId, required bool approve});
}

class LeaveRequestRepositoryImpl implements LeaveRequestRepository {
  LeaveRequestRepositoryImpl(this._service);

  final LeaveRequestService _service;

  @override
  Future<Result<LeaveRequestModel>> createLeaveRequest({
    required String shopId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    try {
      final LeaveRequestModel request = await _service.createLeaveRequest(
        shopId: shopId,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      return Success(request);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<List<LeaveRequestModel>>> fetchMyLeaveRequests() async {
    try {
      final List<LeaveRequestModel> requests = await _service.fetchMyLeaveRequests();
      return Success(requests);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<List<LeaveRequestModel>>> fetchAllLeaveRequests() async {
    try {
      final List<LeaveRequestModel> requests = await _service.fetchAllLeaveRequests();
      return Success(requests);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Failure?> reviewLeaveRequest({required String requestId, required bool approve}) async {
    try {
      await _service.reviewLeaveRequest(requestId: requestId, approve: approve);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } on StateError catch (e) {
      return AuthFailure(e.message);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}