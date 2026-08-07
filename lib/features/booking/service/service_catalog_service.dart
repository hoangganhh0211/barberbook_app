import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/service_model.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho du lieu Dich vu.
class ServiceCatalogService {
  ServiceCatalogService(this._client);

  final SupabaseClient _client;

  /// Danh sach dich vu DANG HOAT DONG (`is_active = true`) cua 1 tiem, sap
  /// xep theo ten. Khong tra ve dich vu da bi Owner tam an (Sprint 8).
  Future<List<ServiceModel>> fetchServicesByShop(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('services')
        .select()
        .eq('shop_id', shopId)
        .eq('is_active', true)
        .order('name');

    return rows.map(ServiceModel.fromJson).toList();
  }
}