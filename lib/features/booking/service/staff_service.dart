import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/staff_model.dart';

/// Tang DUY NHAT duoc phep import `supabase_flutter` cho du lieu Tho.
class StaffService {
  StaffService(this._client);

  final SupabaseClient _client;

  /// Danh sach Tho DANG HOAT DONG cua 1 tiem, sap xep theo rating giam dan.
  Future<List<StaffModel>> fetchStaffByShop(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('staff')
        .select()
        .eq('shop_id', shopId)
        .eq('is_active', true)
        .order('rating', ascending: false);

    return rows.map(StaffModel.fromJson).toList();
  }
}