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

final serviceListProvider = FutureProvider.family<List<ServiceModel>, String>((ref, shopId) async {
  final result = await ref.watch(serviceCatalogRepositoryProvider).fetchServicesByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

final staffListProvider = FutureProvider.family<List<StaffModel>, String>((ref, shopId) async {
  final result = await ref.watch(staffRepositoryProvider).fetchStaffByShop(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

class StaffAvailabilityQuery {
  const StaffAvailabilityQuery({
    required this.shopId,
    required this.staffId,
    required this.serviceId,
    required this.date,
  });

  final String shopId;
  final String staffId;
  final String serviceId;
  final DateTime date;

  @override
  bool operator ==(Object other) =>
      other is StaffAvailabilityQuery &&
      other.shopId == shopId &&
      other.staffId == staffId &&
      other.serviceId == serviceId &&
      other.date.year == date.year &&
      other.date.month == date.month &&
      other.date.day == date.day;

  @override
  int get hashCode => Object.hash(
        shopId,
        staffId,
        serviceId,
        date.year,
        date.month,
        date.day,
      );
}

final availableStaffSlotsProvider =
    FutureProvider.autoDispose.family<List<DateTime>, StaffAvailabilityQuery>((ref, query) async {
  final result = await ref.watch(staffRepositoryProvider).fetchAvailableSlots(
        shopId: query.shopId,
        staffId: query.staffId,
        serviceId: query.serviceId,
        date: query.date,
      );
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
