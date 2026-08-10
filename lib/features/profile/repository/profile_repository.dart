import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/features/profile/service/profile_service.dart';

abstract class ProfileRepository {
  /// Tra ve `null` neu thanh cong, [Failure] neu that bai.
  Future<Failure?> updateFullName(String fullName);
}

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._service);

  final ProfileService _service;

  @override
  Future<Failure?> updateFullName(String fullName) async {
    try {
      await _service.updateFullName(fullName);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } on StateError catch (e) {
      return AuthFailure(e.message);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}