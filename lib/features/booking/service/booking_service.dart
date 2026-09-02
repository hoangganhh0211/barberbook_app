import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/shared/models/booking_model.dart';
class BookingService {
  BookingService(this._client);

  final SupabaseClient _client;
  Future<BookingModel> createBooking({
    required String shopId,
    required String serviceId,
    String? staffId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
  }) async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) {
      throw StateError('Chưa đăng nhập - không thể tạo lịch hẹn.');
    }

    final Map<String, dynamic> row = await _client
        .from('bookings')
        .insert({
          'customer_id': customerId,
          'shop_id': shopId,
          'service_id': serviceId,
          'staff_id': staffId,
          'start_time': startTime.toIso8601String(),
          'end_time': endTime.toIso8601String(),
          'total_price': totalPrice,
        })
        .select()
        .single();

    return BookingModel.fromJson(row);
  }
  Future<List<BookingWithDetails>> fetchMyBookings() async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) {
      throw StateError('Chưa đăng nhập - không thể xem lịch hẹn.');
    }

    final List<Map<String, dynamic>> rows = await _client
        .from('bookings')
        .select('id, shop_id, start_time, end_time, status, total_price, customer_name, '
            'shops(name, cover_image_url), services(name, duration_minutes)')
        .eq('customer_id', customerId)
        .order('start_time', ascending: false);

    return rows.map(BookingWithDetails.fromJson).toList();
  }
  Future<void> cancelBooking(String bookingId) async {
    await _client.from('bookings').update({'status': 'cancelled'}).eq('id', bookingId);
  }
}