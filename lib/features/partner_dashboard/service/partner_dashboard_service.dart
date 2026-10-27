import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/booking/model/booking_with_details.dart';

class PartnerDashboardService {
  PartnerDashboardService(this._client);

  final SupabaseClient _client;

  Future<List<BookingWithDetails>> fetchShopBookings(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('bookings')
        .select(
          'id, shop_id, start_time, end_time, status, total_price, '
          'shops(name, cover_image_url), services(name, duration_minutes)',
        )
        .eq('shop_id', shopId)
        .order('start_time');

    return rows.map(BookingWithDetails.fromJson).toList();
  }
}
