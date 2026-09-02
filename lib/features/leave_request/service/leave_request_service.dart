import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';

class LeaveRequestService {
  LeaveRequestService(this._client);

  final SupabaseClient _client;

  Future<LeaveRequestModel> createLeaveRequest({
    required String shopId,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
  }) async {
    final String? staffProfileId = _client.auth.currentUser?.id;
    if (staffProfileId == null) {
      throw StateError('Chưa đăng nhập - không thể tạo đơn xin nghỉ.');
    }

    final Map<String, dynamic> row = await _client
        .from('leave_requests')
        .insert({
          'staff_profile_id': staffProfileId,
          'shop_id': shopId,
          'start_date': _dateOnly(startDate),
          'end_date': _dateOnly(endDate),
          'reason': reason,
        })
        .select()
        .single();

    return LeaveRequestModel.fromJson(row);
  }

  Future<List<LeaveRequestModel>> fetchMyLeaveRequests() async {
    final String? staffProfileId = _client.auth.currentUser?.id;
    if (staffProfileId == null) {
      throw StateError('Chưa đăng nhập - không thể xem đơn xin nghỉ.');
    }

    final List<Map<String, dynamic>> rows = await _client
        .from('leave_requests')
        .select()
        .eq('staff_profile_id', staffProfileId)
        .order('created_at', ascending: false);

    return rows.map(LeaveRequestModel.fromJson).toList();
  }

  Future<List<LeaveRequestModel>> fetchAllLeaveRequests() async {
    final List<Map<String, dynamic>> rows = await _client
        .from('leave_requests')
        .select()
        .order('created_at', ascending: false);

    return rows.map(LeaveRequestModel.fromJson).toList();
  }

  Future<void> reviewLeaveRequest({
    required String requestId,
    required bool approve,
  }) async {
    final String? reviewerId = _client.auth.currentUser?.id;
    if (reviewerId == null) {
      throw StateError('Chưa đăng nhập - không thể duyệt đơn.');
    }

    await _client.from('leave_requests').update({
      'status': approve ? 'approved' : 'rejected',
      'reviewed_by': reviewerId,
      'reviewed_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}