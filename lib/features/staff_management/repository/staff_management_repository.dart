import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/staff_management/service/staff_management_service.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

abstract class StaffManagementRepository {
  Future<Result<List<StaffModel>>> fetchStaffByShop(String shopId);

  Future<Result<StaffModel>> createStaff({
    required String shopId,
    required String fullName,
    String? bio,
  });

  Future<Failure?> updateStaff({
    required String staffId,
    required String fullName,
    String? bio,
    required bool isActive,
  });

  Future<Failure?> deleteStaff(String staffId);

  Future<Failure?> linkStaffToProfile({required String staffId, required String phone});

  Future<Failure?> unlinkStaffProfile(String staffId);
}

class StaffManagementRepositoryImpl implements StaffManagementRepository {
  StaffManagementRepositoryImpl(this._service);

  final StaffManagementService _service;

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

  @override
  Future<Result<StaffModel>> createStaff({
    required String shopId,
    required String fullName,
    String? bio,
  }) async {
    try {
      final StaffModel staff = await _service.createStaff(
        shopId: shopId,
        fullName: fullName,
        bio: bio,
      );
      return Success(staff);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Failure?> updateStaff({
    required String staffId,
    required String fullName,
    String? bio,
    required bool isActive,
  }) async {
    try {
      await _service.updateStaff(
        staffId: staffId,
        fullName: fullName,
        bio: bio,
        isActive: isActive,
      );
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }

  @override
  Future<Failure?> deleteStaff(String staffId) async {
    try {
      await _service.deleteStaff(staffId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }

  @override
  Future<Failure?> linkStaffToProfile({required String staffId, required String phone}) async {
    try {
      await _service.linkStaffToProfile(staffId: staffId, phone: phone);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }

  @override
  Future<Failure?> unlinkStaffProfile(String staffId) async {
    try {
      await _service.unlinkStaffProfile(staffId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}