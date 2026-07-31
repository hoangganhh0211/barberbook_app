import 'package:flutter/material.dart';

import 'package:barberbook_app/core/enums/user_role.dart';

/// An/hien 1 widget con dua vao Role hien tai - ap dung cho UI-level RBAC
/// (vd: nut "Them nhan vien" chi Owner/Manager moi thay - dung bang RBAC
/// muc 2.5.1 trong tai lieu).
///
/// BAN TOI GIAN o Sprint 0 - chi check theo [UserRole]. Tu Sprint 7 se mo
/// rong nhan them danh sach permission granular (vd: `manage_staff`,
/// `assign_roles`) tu server thay vi suy luan cung tu Role, vi tai lieu co
/// noi ro "Co the tao Role tuy chinh voi tap permission rieng" (muc 2.4.6).
///
/// QUAN TRONG: day CHI la lop bao ve UI (UX tot hon, an nut nguoi dung
/// khong duoc bam). Server van PHAI validate lai quyen o middleware (403)
/// - khong duoc coi day la lop bao mat duy nhat.
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
