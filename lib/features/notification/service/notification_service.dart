import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/notification/model/notification_model.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho du lieu Thong bao.
class NotificationService {
  NotificationService(this._client);

  final SupabaseClient _client;

  Future<List<NotificationModel>> fetchMyNotifications() async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) {
      throw StateError('Chưa đăng nhập - không thể xem thông báo.');
    }

    final List<Map<String, dynamic>> rows = await _client
        .from('notifications')
        .select()
        .eq('customer_id', customerId)
        .order('created_at', ascending: false);

    return rows.map(NotificationModel.fromJson).toList();
  }

  Future<void> markAsRead(String notificationId) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', notificationId);
  }

  Future<void> markAllAsRead() async {
    final String? customerId = _client.auth.currentUser?.id;
    if (customerId == null) return;

    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('customer_id', customerId)
        .eq('is_read', false);
  }
}