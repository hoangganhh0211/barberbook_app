import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell cho khu vuc Partner (Owner/Manager/Receptionist/Staff).
///
/// Da doi chieu voi sidebar Web Admin (vai tro "ADMIN-1234" = Owner 1 tiem,
/// KHONG phai "SUPER ADMIN" toan he thong) - xem bang phan tich trong
/// `route_paths.dart`. 5 tab hien tai la DU va DUNG pham vi cho mobile:
/// Dashboard (gom ca "Quan ly lich hen" + "Bao cao" rut gon), Lich lam viec,
/// Nhan su, Dich vu. Cac muc it dung (Voucher, Thanh toan, Bao mat, Ho tro)
/// KHONG lam tab rieng ma nam trong menu con cua tab "Ca nhan"
/// (`RoutePaths.partnerVouchers/partnerPayments/partnerSecurity/partnerSupport`).
///
/// LUU Y - se hoan thien o Sprint 7 (US-STAFF-002, RBAC Matrix):
/// hien tai ca 5 tab deu hien thi cho MOI partner role. Tu Sprint 7, tab
/// "Nhan su" va "Dich vu" se bi AN hoan toan (khong chi disable) doi voi
/// Receptionist/Staff theo dung bang phan quyen trong tai lieu, thong qua
/// `PermissionGuard` (xem `core/widgets/permission_guard.dart`).
class PartnerShellScreen extends StatelessWidget {
  const PartnerShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Lịch làm việc'),
          NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Nhân sự'),
          NavigationDestination(icon: Icon(Icons.content_cut_outlined), selectedIcon: Icon(Icons.content_cut), label: 'Dịch vụ'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Cá nhân'),
        ],
      ),
    );
  }
}
