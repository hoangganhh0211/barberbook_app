import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';
import 'package:barberbook_app/features/leave_request/repository/leave_request_repository.dart';
import 'package:barberbook_app/features/leave_request/service/leave_request_service.dart';

final leaveRequestServiceProvider = Provider<LeaveRequestService>((ref) {
  return LeaveRequestService(ref.watch(supabaseClientProvider));
});

final leaveRequestRepositoryProvider = Provider<LeaveRequestRepository>((ref) {
  return LeaveRequestRepositoryImpl(ref.watch(leaveRequestServiceProvider));
});


final myLeaveRequestsProvider = FutureProvider<List<LeaveRequestModel>>((ref) async {
  final result = await ref.watch(leaveRequestRepositoryProvider).fetchMyLeaveRequests();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});


final allLeaveRequestsProvider = FutureProvider<List<LeaveRequestModel>>((ref) async {
  final result = await ref.watch(leaveRequestRepositoryProvider).fetchAllLeaveRequests();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});