import 'package:barberbook_app/features/partner_dashboard/screen/partner_dashboard_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/auth/screen/login_screen.dart';
import 'package:barberbook_app/features/auth/screen/register_screen.dart';
import 'package:barberbook_app/features/booking/screen/booking_confirm_screen.dart';
import 'package:barberbook_app/features/booking/screen/booking_date_time_screen.dart';
import 'package:barberbook_app/features/booking/screen/booking_service_staff_screen.dart';
import 'package:barberbook_app/features/booking/screen/my_bookings_screen.dart';
import 'package:barberbook_app/features/leave_request/screen/leave_approval_screen.dart';
import 'package:barberbook_app/features/leave_request/screen/leave_request_screen.dart';
import 'package:barberbook_app/features/home_customer/screen/customer_shell_screen.dart';
import 'package:barberbook_app/features/home_customer/screen/home_customer_screen.dart';
import 'package:barberbook_app/features/notification/screen/notification_center_screen.dart';
import 'package:barberbook_app/features/partner_dashboard/screen/partner_shell_screen.dart';
import 'package:barberbook_app/features/profile/screen/profile_screen.dart';
import 'package:barberbook_app/features/search_shop_stylist/screen/shop_detail_screen.dart';
import 'package:barberbook_app/features/search_shop_stylist/screen/shop_list_screen.dart';
import 'package:barberbook_app/features/splash/screen/splash_screen.dart';
import 'package:barberbook_app/features/staff_management/screen/edit_staff_screen.dart';
import 'package:barberbook_app/features/staff_management/screen/staff_management_screen.dart';
import 'package:barberbook_app/features/staff_schedule/screen/staff_schedule_screen.dart';
import 'package:barberbook_app/features/service_management/screen/service_management_screen.dart';
import 'package:barberbook_app/routes/route_guard.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';
import 'package:barberbook_app/features/profile/screen/partner_profile_screen.dart';
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
        path: '${RoutePaths.customerShops}/:shopId',
        builder: (context, state) {
          final String shopId = state.pathParameters['shopId']!;
          return ShopDetailScreen(shopId: shopId);
        },
      ),
      GoRoute(
        path: RoutePaths.bookingSelectServiceStaff,
        builder: (context, state) => const BookingServiceStaffScreen(),
      ),
      GoRoute(
        path: RoutePaths.bookingSelectDateTime,
        builder: (context, state) => const BookingDateTimeScreen(),
      ),
      GoRoute(
        path: RoutePaths.bookingConfirm,
        builder: (context, state) => const BookingConfirmScreen(),
      ),
      GoRoute(
        path: RoutePaths.partnerLeaveRequests,
        builder: (context, state) => const LeaveRequestScreen(),
      ),
      GoRoute(
        path: RoutePaths.partnerLeaveApproval,
        builder: (context, state) => const LeaveApprovalScreen(),
      ),
      GoRoute(
        path: RoutePaths.partnerStaffEdit,
        builder: (context, state) => EditStaffScreen(staff: state.extra! as StaffModel),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            CustomerShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerHome,
              builder: (context, state) => const HomeCustomerScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerBookings,
              builder: (context, state) => const MyBookingsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerShops,
              builder: (context, state) => const ShopListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerNotifications,
              builder: (context, state) => const NotificationCenterScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.customerProfile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            PartnerShellScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerDashboard,
              builder: (context, state) => const PartnerDashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerSchedule,
              builder: (context, state) => const StaffScheduleScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerStaff,
              builder: (context, state) => const StaffManagementScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerServices,
              builder: (context, state) => const ServiceManagementScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.partnerProfile,
              builder: (context, state) => const PartnerProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});