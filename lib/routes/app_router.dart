import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/widgets/placeholder_screen.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/auth/screen/login_screen.dart';
import 'package:barberbook_app/features/auth/screen/otp_screen.dart';
import 'package:barberbook_app/features/auth/screen/register_screen.dart';
import 'package:barberbook_app/features/home_customer/screen/customer_shell_screen.dart';
import 'package:barberbook_app/features/partner_dashboard/screen/partner_shell_screen.dart';
import 'package:barberbook_app/features/splash/screen/splash_screen.dart';
import 'package:barberbook_app/routes/route_guard.dart';
import 'package:barberbook_app/routes/route_paths.dart';

/// Provider duy nhat cung cap [GoRouter] cho toan app (dung trong `app.dart`
/// qua `MaterialApp.router(routerConfig: ref.watch(appRouterProvider))`).
///
/// KHONG tao GoRouter() o bat ky noi nao khac - moi thay doi ve routing
/// (them route, doi redirect...) chi sua trong file nay va `route_guard.dart`.
final appRouterProvider = Provider<GoRouter>((ref) {
  final RouterRefreshNotifier refreshNotifier = RouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final AuthState authState = ref.read(authControllerProvider);
      return routeGuardRedirect(authState, state);
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RoutePaths.registerOtp,
        builder: (context, state) {
          final Object? extra = state.extra;
          if (extra is OtpScreenArgs) {
            return OtpScreen(args: extra);
          }
          // Truong hop hiem: nguoi dung vao thang URL nay (vd: reload trang
          // tren Flutter Web) ma khong qua RegisterScreen nen thieu `extra` -
          // dua ve lai man Dang ky thay vi de app crash vi thieu du lieu.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go(RoutePaths.register);
          });
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        },
      ),

      // ----- Customer Shell -----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CustomerShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerHome,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Trang chủ - Khách hàng'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerBookings,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Đặt lịch'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerShops,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Tiệm'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerNotifications,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Thông báo'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerProfile,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Thông tin'),
            ),
          ]),
        ],
      ),

      // ----- Partner Shell -----
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            PartnerShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerDashboard,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Dashboard - Partner'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerSchedule,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Lịch làm việc của tôi'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerStaff,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Quản lý Nhân sự'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerServices,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Cấu hình Dịch vụ / Combo'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerProfile,
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Cá nhân - Partner'),
            ),
          ]),
        ],
      ),
    ],
  );
});
