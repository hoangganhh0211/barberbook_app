import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/shared/models/staff_model.dart';

class StaffService {
  StaffService(this._client);

  final SupabaseClient _client;

  Future<List<StaffModel>> fetchStaffByShop(String shopId) async {
    final List<Map<String, dynamic>> rows = await _client
        .from('staff')
        .select()
        .eq('shop_id', shopId)
        .eq('is_active', true)
        .not('profile_id', 'is', null)
        .order('rating', ascending: false);

    return rows.map(StaffModel.fromJson).toList();
  }

  Future<List<DateTime>> fetchAvailableSlots({
    required String shopId,
    required String staffId,
    required String serviceId,
    required DateTime date,
  }) async {
    final String dateValue =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final dynamic response = await _client.rpc(
      'get_available_staff_slots',
      params: <String, dynamic>{
        'p_shop_id': shopId,
        'p_staff_id': staffId,
        'p_service_id': serviceId,
        'p_date': dateValue,
      },
    );

    final rows = response as List<dynamic>;
    return rows
        .map((row) => DateTime.parse(row['start_time'] as String).toUtc())
        .toList(growable: false);
  }
}
