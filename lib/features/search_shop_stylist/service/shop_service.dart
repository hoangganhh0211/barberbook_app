import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/shop_model.dart';

/// Tang DUY NHAT trong feature nay duoc phep import `supabase_flutter` va
/// biet ten bang/cot trong Postgres. Repository/Provider/UI phia tren chi
/// lam viec voi [ShopModel], khong biet gi ve Supabase.
class ShopService {
  ShopService(this._client);

  final SupabaseClient _client;

  /// Lay danh sach tiem, sap xep theo rating giam dan (tiem tot nhat len
  /// dau). [searchQuery] loc theo ten tiem (khong phan biet hoa/thuong,
  /// khop 1 phan) - de trong hoac null se tra ve TOAN BO tiem.
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
