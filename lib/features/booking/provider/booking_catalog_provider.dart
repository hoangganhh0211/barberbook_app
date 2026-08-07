import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/repository/service_catalog_repository.dart';
import 'package:barberbook_app/features/booking/repository/staff_repository.dart';
import 'package:barberbook_app/features/booking/service/service_catalog_service.dart';
import 'package:barberbook_app/features/booking/service/staff_service.dart';
import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

final serviceCatalogServiceProvider = Provider<ServiceCatalogService>((ref) {
  return ServiceCatalogService(ref.watch(supabaseClientProvider));
});

final serviceCatalogRepositoryProvider = Provider<ServiceCatalogRepository>((ref) {
  return ServiceCatalogRepositoryImpl(ref.watch(serviceCatalogServiceProvider));
});

final staffServiceProvider = Provider<StaffService>((ref) {
  return StaffService(ref.watch(supabaseClientProvider));
});

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepositoryImpl(ref.watch(staffServiceProvider));
});

/// Danh sach Dich vu cua 1 tiem (theo `shopId`) - dung o Buoc 1 luong Dat lich.
final serviceListProvider = FutureProvider.family<List<ServiceModel>, String>((ref, shopId) async {
  final result = await ref.watch(serviceCatalogRepositoryProvider).fetchServicesByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

/// Danh sach Tho cua 1 tiem (theo `shopId`) - dung o Buoc 2 luong Dat lich.
final staffListProvider = FutureProvider.family<List<StaffModel>, String>((ref, shopId) async {
  final result = await ref.watch(staffRepositoryProvider).fetchStaffByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});