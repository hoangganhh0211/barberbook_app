import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/routes/route_paths.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, __) => notifyListeners());
  }
}

String? routeGuardRedirect(AuthState authState, GoRouterState routerState) {
  final String location = routerState.matchedLocation;
  final bool isOnSplash = location == RoutePaths.splash;
  final bool isOnPreAuthArea = location == RoutePaths.login || location == RoutePaths.register;
  final bool isOnCustomerArea = location.startsWith(RoutePaths.customerRoot);
  final bool isOnPartnerArea = location.startsWith(RoutePaths.partnerRoot);

  return switch (authState) {
    AuthUnknown() => isOnSplash ? null : RoutePaths.splash,
    AuthUnauthenticated() => isOnPreAuthArea ? null : RoutePaths.login,
    AuthAuthenticated(:final session) => _redirectForAuthenticated(
        role: session.role,
        location: location,
        isOnSplash: isOnSplash,
        isOnPreAuthArea: isOnPreAuthArea,
        isOnCustomerArea: isOnCustomerArea,
        isOnPartnerArea: isOnPartnerArea,
      ),
  };
}

String? _redirectForAuthenticated({
  required UserRole role,
  required String location,
  required bool isOnSplash,
  required bool isOnPreAuthArea,
  required bool isOnCustomerArea,
  required bool isOnPartnerArea,
}) {
  final String homeForRole = role.isCustomer ? RoutePaths.customerHome : _firstPartnerLocation(role);

  if (isOnSplash || isOnPreAuthArea) return homeForRole;

  final bool wrongAreaForCustomer = role.isCustomer && isOnPartnerArea;
  final bool wrongAreaForPartner = role.isPartner && isOnCustomerArea;
  if (wrongAreaForCustomer || wrongAreaForPartner) return homeForRole;

  if (location == RoutePaths.partnerDashboard &&
      !RbacMatrix.allows(role, AppPermission.dashboardView)) {
    return _firstPartnerLocation(role);
  }

  if (location == RoutePaths.partnerSchedule &&
      !RbacMatrix.allows(role, AppPermission.scheduleView)) {
    return RoutePaths.partnerProfile;
  }

  if ((location == RoutePaths.partnerStaff || location == RoutePaths.partnerStaffEdit) &&
      !RbacMatrix.allows(role, AppPermission.staffView)) {
    return _firstPartnerLocation(role);
  }

  if (location == RoutePaths.partnerStaffEdit &&
      !RbacMatrix.allows(role, AppPermission.staffUpdate)) {
    return RoutePaths.partnerStaff;
  }

  if (location == RoutePaths.partnerServices &&
      !RbacMatrix.allows(role, AppPermission.serviceView)) {
    return _firstPartnerLocation(role);
  }

  if (location == RoutePaths.partnerLeaveApproval &&
      !RbacMatrix.allows(role, AppPermission.leaveApprove)) {
    return RoutePaths.partnerSchedule;
  }

  return null;
}

String _firstPartnerLocation(UserRole role) {
  if (RbacMatrix.allows(role, AppPermission.dashboardView)) return RoutePaths.partnerDashboard;
  if (RbacMatrix.allows(role, AppPermission.scheduleView)) return RoutePaths.partnerSchedule;
  return RoutePaths.partnerProfile;
}
