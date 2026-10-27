enum UserRole {
  customer,
  owner,
  staff;

  static UserRole fromServerValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'staff':
        return UserRole.staff;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  bool get isCustomer => this == UserRole.customer;

  bool get isPartner => !isCustomer;

  bool get isShopAdmin => this == UserRole.owner;
}
