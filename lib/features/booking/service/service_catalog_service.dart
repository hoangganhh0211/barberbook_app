import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/service_model.dart';
class ServiceCatalogService {
  ServiceCatalogService(this._client);

  final SupabaseClient _client;
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