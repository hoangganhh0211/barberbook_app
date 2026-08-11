import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/user_role.dart';

class PermissionGuard extends StatelessWidget {
  const PermissionGuard({
    required this.currentRole,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  final UserRole currentRole;
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context) {
    return allowedRoles.contains(currentRole) ? child : fallback;
  }
}
