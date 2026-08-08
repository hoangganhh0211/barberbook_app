import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/shared/models/booking_model.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho du lieu Booking.
class BookingService {
  BookingService(this._client);

  final SupabaseClient _client;

  /// Tao 1 booking moi (`status` mac dinh 'pending' theo DB default, xem
  /// `supabase/schema_bookings.sql`) - CHUA co xac nhan tu Owner/Staff
  /// (thuoc luong Dashboard cua Partner App, Sprint 6-7).
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
      // KHONG the xay ra trong luong nghiep vu binh thuong (route_guard.dart
      // da dam bao chi user da dang nhap moi vao duoc man nay) - phong ve
      // truong hop hiem (vd: session vua het han dung luc bam Xac nhan).
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

  /// Danh sach lich hen cua khach dang dang nhap, kem ten Tiem + ten Dich
  /// vu (Supabase embedded select - 1 lan goi, khong can N+1 query rieng).
  /// Sap xep MOI NHAT len dau (theo `start_time` giam dan).
  Future<List<BookingWithDetails>> fetchMyBookings() async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) {
      throw StateError('Chưa đăng nhập - không thể xem lịch hẹn.');
    }

    final List<Map<String, dynamic>> rows = await _client
        .from('bookings')
        .select('id, start_time, end_time, status, total_price, '
            'shops(name, cover_image_url), services(name, duration_minutes)')
        .eq('customer_id', customerId)
        .order('start_time', ascending: false);

    return rows.map(BookingWithDetails.fromJson).toList();
  }

  /// Huy 1 lich hen - chi doi `status` sang 'cancelled', KHONG xoa dong du
  /// lieu (giu lai lich su cho tab "Lich su"). RLS trong
  /// `supabase/schema_bookings.sql` da dam bao chi khach so huu moi sua
  /// duoc dong nay.
  Future<void> cancelBooking(String bookingId) async {
    await _client.from('bookings').update({'status': 'cancelled'}).eq('id', bookingId);
  }
}