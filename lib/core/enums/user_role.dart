enum UserRole {
  customer,
  owner,
  manager,
  receptionist,
  staff;

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
        return UserRole.customer;
    }
  }

  bool get isCustomer => this == UserRole.customer;


  bool get isPartner => !isCustomer;


  bool get isShopAdmin => this == UserRole.owner || this == UserRole.manager;
}
