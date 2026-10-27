import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/user_role.dart';

abstract class RbacMatrix {
  static const Map<UserRole, Set<AppPermission>> _grants = {
    UserRole.owner: {
      AppPermission.dashboardView,
      AppPermission.staffView,
      AppPermission.staffCreate,
      AppPermission.staffUpdate,
      AppPermission.staffDelete,
      AppPermission.staffLink,
      AppPermission.scheduleView,
      AppPermission.leaveRequest,
      AppPermission.leaveApprove,
      AppPermission.serviceView,
      AppPermission.serviceCreate,
      AppPermission.serviceUpdate,
      AppPermission.serviceToggleActive,
    },
    UserRole.staff: {
      AppPermission.scheduleView,
      AppPermission.leaveRequest,
    },
    UserRole.customer: {},
  };

  static bool allows(UserRole role, AppPermission permission) {
    return _grants[role]?.contains(permission) ?? false;
  }

  static List<UserRole> rolesWith(AppPermission permission) {
    return [
      for (final UserRole role in UserRole.values)
        if (allows(role, permission)) role,
    ];
  }
}
