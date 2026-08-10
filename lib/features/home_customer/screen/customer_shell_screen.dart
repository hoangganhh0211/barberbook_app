import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/features/notification/provider/notification_provider.dart';

/// Shell (khung Bottom Navigation) cho toan bo khu vuc Khach hang.
///
/// Dung `StatefulShellRoute.indexedStack` cua go_router (xem `app_router.dart`)
/// nen [navigationShell] tu dong giu state rieng cho tung tab (khong bi
/// rebuild lai tu dau khi chuyen tab qua lai) - dung UX yeu cau cho app
/// booking (vd: giu vi tri scroll cua tab Tim kiem khi chuyen sang tab khac).
class CustomerShellScreen extends ConsumerWidget {
  const CustomerShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int unreadCount = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => navigationShell.goBranch(
          index,
          // Neu bam lai tab dang dung -> quay ve root cua tab do (UX chuan).
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Đặt lịch',
          ),
          const NavigationDestination(
            icon: Icon(Icons.content_cut_outlined),
            selectedIcon: Icon(Icons.content_cut),
            label: 'Tiệm',
          ),
          NavigationDestination(
            // Badge so thong bao chua doc - Riverpod tu rebuild moi khi
            // `unreadNotificationCountProvider` doi (vd: sau khi doc 1
            // thong bao o tab "Thong bao"), khong can tu quan ly state rieng.
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications),
            ),
            label: 'Thông báo',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Thông tin',
          ),
        ],
      ),
    );
  }
}