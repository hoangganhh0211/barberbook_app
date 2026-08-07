import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/service/staff_service.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

abstract class StaffRepository {
  Future<Result<List<StaffModel>>> fetchStaffByShop(String shopId);
}

class StaffRepositoryImpl implements StaffRepository {
  StaffRepositoryImpl(this._service);

  final StaffService _service;

  @override
  Future<Result<List<StaffModel>>> fetchStaffByShop(String shopId) async {
    try {
      final List<StaffModel> staff = await _service.fetchStaffByShop(shopId);
      return Success(staff);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }
}