import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/staff_management/repository/staff_management_repository.dart';
import 'package:barberbook_app/features/staff_management/service/staff_management_service.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

final staffManagementServiceProvider = Provider<StaffManagementService>((ref) {
  return StaffManagementService(ref.watch(supabaseClientProvider));
});

final staffManagementRepositoryProvider = Provider<StaffManagementRepository>((ref) {
  return StaffManagementRepositoryImpl(ref.watch(staffManagementServiceProvider));
});

final shopStaffListProvider = FutureProvider.family<List<StaffModel>, String>((ref, shopId) async {
  final result = await ref.watch(staffManagementRepositoryProvider).fetchStaffByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});