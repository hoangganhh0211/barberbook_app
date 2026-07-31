import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shell (khung Bottom Navigation) cho toan bo khu vuc Khach hang.
///
/// Dung `StatefulShellRoute.indexedStack` cua go_router (xem `app_router.dart`)
/// nen [navigationShell] tu dong giu state rieng cho tung tab (khong bi
/// rebuild lai tu dau khi chuyen tab qua lai) - dung UX yeu cau cho app
/// booking (vd: giu vi tri scroll cua tab Tim kiem khi chuyen sang tab khac).
class CustomerShellScreen extends StatelessWidget {
  const CustomerShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          // Neu bam lai tab dang dung -> quay ve root cua tab do (UX chuan).
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Đặt lịch'),
          NavigationDestination(icon: Icon(Icons.content_cut_outlined), selectedIcon: Icon(Icons.content_cut), label: 'Tiệm'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications), label: 'Thông báo'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Thông tin'),
        ],
      ),
    );
  }
}
