abstract class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String customerRoot = '/customer';
  static const String customerHome = '/customer/home';
  static const String customerBookings = '/customer/bookings'; // tab "Dat lich"
  static const String customerShops = '/customer/shops'; // tab "Tiem" (gop chuc nang tim kiem + danh sach tiem)
  static String customerShopDetail(String shopId) => '$customerShops/$shopId';
  static const String customerNotifications = '/customer/notifications'; // tab "Thong bao"
  static const String customerProfile = '/customer/profile'; // tab "Thong tin"
  static const String customerWallet = '/customer/profile/wallet';
  static const String partnerRoot = '/partner';
  static const String partnerDashboard = '/partner/dashboard';
  static const String partnerSchedule = '/partner/schedule';
  static const String partnerStaff = '/partner/staff';
  static const String partnerServices = '/partner/services';
  static const String partnerProfile = '/partner/profile';
  static const String partnerVouchers = '/partner/profile/vouchers';
  static const String partnerPayments = '/partner/profile/payments';
  static const String partnerSecurity = '/partner/profile/security';

  static const String partnerSupport = '/partner/profile/support';
  static const String bookingSelectServiceStaff = '/booking/select';
  static const String bookingSelectDateTime = '/booking/datetime';
  static const String bookingConfirm = '/booking/confirm';
}