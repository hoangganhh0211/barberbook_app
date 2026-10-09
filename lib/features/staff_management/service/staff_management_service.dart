import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/utils/phone_utils.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

class StaffManagementService {
  StaffManagementService(this._client);

  final SupabaseClient _client;

  Future<List<StaffModel>> fetchStaffByShop(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('staff')
        .select()
        .eq('shop_id', shopId)
        .order('created_at');

    return rows.map(StaffModel.fromJson).toList();
  }

  Future<StaffModel> createStaff({
    required String shopId,
    required String fullName,
    String? bio,
  }) async {
    final Map<String, dynamic> row = await _client
        .from('staff')
        .insert({'shop_id': shopId, 'full_name': fullName, 'bio': bio})
        .select()
        .single();

    return StaffModel.fromJson(row);
  }

  Future<void> updateStaff({
    required String staffId,
    required String fullName,
    String? bio,
    required bool isActive,
  }) async {
    await _client.from('staff').update({
      'full_name': fullName,
      'bio': bio,
      'is_active': isActive,
    }).eq('id', staffId);
  }

  Future<void> deleteStaff(String staffId) async {
    await _client.from('staff').delete().eq('id', staffId);
  }

  Future<void> linkStaffToProfile({required String staffId, required String phone}) {
    return _client.rpc('link_staff_to_profile', params: {
      'p_staff_id': staffId,
      'p_phone': normalizePhone(phone),
    });
  }

  Future<void> unlinkStaffProfile(String staffId) {
    return _client.rpc('unlink_staff_profile', params: {'p_staff_id': staffId});
  }
}