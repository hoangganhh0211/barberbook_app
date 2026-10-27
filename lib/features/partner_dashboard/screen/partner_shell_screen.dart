import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';

class PartnerShellScreen extends ConsumerWidget {
  const PartnerShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final role = authState is AuthAuthenticated ? authState.session.role : null;

    final List<_PartnerDestination> destinations = <_PartnerDestination>[
      if (role != null && RbacMatrix.allows(role, AppPermission.dashboardView))
        const _PartnerDestination(
          branchIndex: 0,
          destination: NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ),
      if (role != null && RbacMatrix.allows(role, AppPermission.scheduleView))
        const _PartnerDestination(
          branchIndex: 1,
          destination: NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Lịch làm việc',
          ),
        ),
      if (role != null && RbacMatrix.allows(role, AppPermission.staffView))
        const _PartnerDestination(
          branchIndex: 2,
          destination: NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Nhân sự',
          ),
        ),
      if (role != null && RbacMatrix.allows(role, AppPermission.serviceView))
        const _PartnerDestination(
          branchIndex: 3,
          destination: NavigationDestination(
            icon: Icon(Icons.content_cut_outlined),
            selectedIcon: Icon(Icons.content_cut),
            label: 'Dịch vụ',
          ),
        ),
      // Profile is available to all partner roles so they can view account
      // details and sign out.
      const _PartnerDestination(
        branchIndex: 4,
        destination: NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Cá nhân',
        ),
      ),
    ];

    final int selectedIndex = destinations.indexWhere(
      (destination) => destination.branchIndex == navigationShell.currentIndex,
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
        onDestinationSelected: (int visibleIndex) {
          final int branchIndex = destinations[visibleIndex].branchIndex;
          navigationShell.goBranch(
            branchIndex,
            initialLocation: branchIndex == navigationShell.currentIndex,
          );
        },
        destinations: destinations.map((item) => item.destination).toList(),
      ),
    );
  }
}

class _PartnerDestination {
  const _PartnerDestination({required this.branchIndex, required this.destination});

  final int branchIndex;
  final NavigationDestination destination;
}
