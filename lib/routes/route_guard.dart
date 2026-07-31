import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/routes/route_paths.dart';

/// Cau [ChangeNotifier] de lam cau noi giua Riverpod ([AuthController]) va
/// `GoRouter.refreshListenable` (GoRouter chi hieu ve `Listenable`, khong
/// hieu ve Riverpod Provider truc tiep).
///
/// Moi khi [authControllerProvider] thay doi state (dang nhap/dang xuat),
/// `notifyListeners()` duoc goi -> GoRouter tu dong chay lai ham `redirect`
/// ben duoi de dieu huong lai cho dung.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(Ref ref) {
    ref.listen<AuthState>(authControllerProvider, (_, __) => notifyListeners());
  }
}

/// Logic redirect trung tam - noi DUY NHAT quyet dinh:
/// 1. Chua biet trang thai auth -> o lai Splash.
/// 2. Chua dang nhap -> ep ve Login.
/// 3. Da dang nhap nhung dang o Splash/Login -> dua vao dung Shell theo Role.
/// 4. Da dang nhap nhung co truy cap sai khu vuc (Customer vao /partner/...
///    hoac nguoc lai) -> dua ve dung Shell cua minh (chan truy cap cheo).
String? routeGuardRedirect(AuthState authState, GoRouterState routerState) {
  final String location = routerState.matchedLocation;
  final bool isOnSplash = location == RoutePaths.splash;
  final bool isOnLogin = location == RoutePaths.login;
  final bool isOnCustomerArea = location.startsWith(RoutePaths.customerRoot);
  final bool isOnPartnerArea = location.startsWith(RoutePaths.partnerRoot);

  return switch (authState) {
    AuthUnknown() => isOnSplash ? null : RoutePaths.splash,
    AuthUnauthenticated() => isOnLogin ? null : RoutePaths.login,
    AuthAuthenticated(:final session) => _redirectForAuthenticated(
        role: session.role,
        isOnSplash: isOnSplash,
        isOnLogin: isOnLogin,
        isOnCustomerArea: isOnCustomerArea,
        isOnPartnerArea: isOnPartnerArea,
      ),
  };
}

String? _redirectForAuthenticated({
  required UserRole role,
  required bool isOnSplash,
  required bool isOnLogin,
  required bool isOnCustomerArea,
  required bool isOnPartnerArea,
}) {
  final String homeForRole =
      role.isCustomer ? RoutePaths.customerHome : RoutePaths.partnerDashboard;

  if (isOnSplash || isOnLogin) {
    return homeForRole;
  }

  final bool wrongAreaForCustomer = role.isCustomer && isOnPartnerArea;
  final bool wrongAreaForPartner = role.isPartner && isOnCustomerArea;
  if (wrongAreaForCustomer || wrongAreaForPartner) {
    return homeForRole;
  }

  return null; // khong can redirect
}
