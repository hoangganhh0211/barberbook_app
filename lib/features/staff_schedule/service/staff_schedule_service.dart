import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/booking/model/booking_with_details.dart';

class StaffScheduleService {
  StaffScheduleService(this._client);

  final SupabaseClient _client;

  Future<String?> fetchMyStaffId() async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final Map<String, dynamic>? row = await _client
        .from('staff')
        .select('id')
        .eq('profile_id', userId)
        .maybeSingle();

    return row?['id'] as String?;
  }

  Future<({String id, String shopId})?> fetchMyStaffInfo() async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final Map<String, dynamic>? row = await _client
        .from('staff')
        .select('id, shop_id')
        .eq('profile_id', userId)
        .maybeSingle();

    if (row == null) return null;
    return (id: row['id'] as String, shopId: row['shop_id'] as String);
  }

  Future<void> completeBooking(String bookingId) async {
    await _client.rpc(
      'complete_booking',
      params: <String, dynamic>{'p_booking_id': bookingId},
    );
  }

  Future<List<BookingWithDetails>> fetchMySchedule({
    required DateTime rangeStart,
    required DateTime rangeEnd,
  }) async {
    final String? staffId = await fetchMyStaffId();
    if (staffId == null) return [];

    final List<Map<String, dynamic>> rows = await _client
        .from('bookings')
        .select('id, shop_id, start_time, end_time, status, total_price, customer_name, '
            'shops(name, cover_image_url), services(name, duration_minutes)')
        .eq('staff_id', staffId)
        .gte('start_time', rangeStart.toIso8601String())
        .lte('start_time', rangeEnd.toIso8601String())
        .order('start_time');

    return rows.map(BookingWithDetails.fromJson).toList();
  }
}