import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/shop_model.dart';
class ShopService {
  ShopService(this._client);

  final SupabaseClient _client;
  Future<List<ShopModel>> fetchShops({String? searchQuery}) async {
    final String trimmedQuery = (searchQuery ?? '').trim();

    final PostgrestFilterBuilder<List<Map<String, dynamic>>> query = _client
        .from('shops')
        .select();

    final PostgrestFilterBuilder<List<Map<String, dynamic>>> filteredQuery =
        trimmedQuery.isEmpty ? query : query.ilike('name', '%$trimmedQuery%');

    final List<Map<String, dynamic>> rows =
        await filteredQuery.order('rating', ascending: false);

    return rows.map(ShopModel.fromJson).toList();
  }

  Future<ShopModel> fetchShopById(String shopId) async {
    final Map<String, dynamic> row =
        await _client.from('shops').select().eq('id', shopId).single();
    return ShopModel.fromJson(row);
  }
}
