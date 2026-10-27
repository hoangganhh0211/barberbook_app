import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/service_management/model/service_admin_item.dart';
import 'package:barberbook_app/features/service_management/service/service_management_service.dart';

final serviceManagementServiceProvider = Provider<ServiceManagementService>((ref) {
  return ServiceManagementService(ref.watch(supabaseClientProvider));
});

final serviceManagementListProvider =
    FutureProvider.family<List<ServiceAdminItem>, String>((ref, shopId) async {
  // Make the provider depend on the active account, so a cached list cannot
  // survive a sign-out/sign-in boundary.
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return <ServiceAdminItem>[];
  return ref.watch(serviceManagementServiceProvider).fetchServices(shopId);
});
