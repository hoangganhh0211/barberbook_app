import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/features/service_management/model/service_admin_item.dart';

class ServiceManagementService {
  ServiceManagementService(this._client);

  final SupabaseClient _client;

  Future<List<ServiceAdminItem>> fetchServices(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('services')
        .select()
        .eq('shop_id', shopId)
        .order('created_at', ascending: false);
    return rows.map(ServiceAdminItem.fromJson).toList();
  }

  Future<void> createService({
    required String shopId,
    required ServiceFormData data,
  }) async {
    await _client.from('services').insert(_toPayload(shopId, data));
  }

  Future<void> updateService({
    required String shopId,
    required String serviceId,
    required ServiceFormData data,
  }) async {
    final Map<String, dynamic>? updated = await _client
        .from('services')
        .update(_toPayload(shopId, data))
        .eq('id', serviceId)
        .eq('shop_id', shopId)
        .select('id')
        .maybeSingle();

    if (updated == null) {
      throw StateError('Không tìm thấy dịch vụ hoặc bạn không có quyền chỉnh sửa.');
    }
  }

  Future<void> setServiceActive({
    required String shopId,
    required String serviceId,
    required bool isActive,
  }) async {
    final Map<String, dynamic>? updated = await _client
        .from('services')
        .update({'is_active': isActive})
        .eq('id', serviceId)
        .eq('shop_id', shopId)
        .select('id')
        .maybeSingle();

    if (updated == null) {
      throw StateError('Không tìm thấy dịch vụ hoặc bạn không có quyền cập nhật.');
    }
  }

  Map<String, dynamic> _toPayload(String shopId, ServiceFormData data) {
    return <String, dynamic>{
      'shop_id': shopId,
      'name': data.name.trim(),
      'description': _emptyToNull(data.description),
      'price': data.price,
      'duration_minutes': data.durationMinutes,
      'image_url': _emptyToNull(data.imageUrl),
    };
  }

  String? _emptyToNull(String? value) {
    final String normalized = (value ?? '').trim();
    return normalized.isEmpty ? null : normalized;
  }
}
