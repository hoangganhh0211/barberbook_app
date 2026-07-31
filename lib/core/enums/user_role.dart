/// Vai tro cua user trong he thong BarberBook.
///
/// Dung de:
/// - Dieu huong Shell phu hop sau khi dang nhap (xem `route_guard.dart`).
/// - Kiem soat hien thi UI theo RBAC (xem `PermissionGuard`).
///
/// LUU Y: enum nay phai dong bo tuyet doi voi gia tri `role` server tra ve
/// trong JWT / user profile response. Neu BE doi ten role, phai cap nhat
/// `fromServerValue` tuong ung - khong sua rai rac o nhieu noi khac.
enum UserRole {
  customer,
  owner,
  manager,
  receptionist,
  staff;

  /// Map gia tri string tu server (vd: "owner", "super_admin"...) sang enum.
  /// Fallback ve [UserRole.customer] neu gia tri la unknown de tranh crash -
  /// nhung se log canh bao (xem TODO) vi day la dau hieu BE/FE lech contract.
  static UserRole fromServerValue(String value) {
    switch (value.toLowerCase()) {
      case 'customer':
        return UserRole.customer;
      case 'owner':
        return UserRole.owner;
      case 'manager':
      case 'super_admin':
        return UserRole.manager;
      case 'receptionist':
        return UserRole.receptionist;
      case 'staff':
        return UserRole.staff;
      default:
        // TODO(auth): gui log/crashlytics khi gap role la (BE/FE contract mismatch)
        return UserRole.customer;
    }
  }

  bool get isCustomer => this == UserRole.customer;

  /// True neu la mot trong cac role thuoc "Partner App" (Owner/Staff side).
  bool get isPartner => !isCustomer;

  /// True neu co quyen quan tri cao nhat trong pham vi shop (theo bang RBAC
  /// trong tai lieu US-STAFF-002 / US-ADMIN-003).
  bool get isShopAdmin => this == UserRole.owner || this == UserRole.manager;
}
