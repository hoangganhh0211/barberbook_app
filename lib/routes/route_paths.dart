/// Tap trung toan bo path cua app. Khi them route moi cho 1 feature, khai
/// bao path o day truoc, sau do moi dung trong `app_router.dart` va khi
/// `context.go(...)` / `context.push(...)` tu cac Screen.
abstract class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  // ----- Customer Shell (5 tab dung theo Figma: Home/Dat lich/Tiem/Thong bao/Thong tin) -----
  static const String customerRoot = '/customer';
  static const String customerHome = '/customer/home';
  static const String customerBookings = '/customer/bookings'; // tab "Dat lich"
  static const String customerShops = '/customer/shops'; // tab "Tiem" (gop chuc nang tim kiem + danh sach tiem)

  /// Path man Chi tiet Tiem - route RIENG (khong nam trong ShellRoute) de
  /// khong hien Bottom Navigation, dung `context.push(customerShopDetail(id))`.
  static String customerShopDetail(String shopId) => '$customerShops/$shopId';
  static const String customerNotifications = '/customer/notifications'; // tab "Thong bao"
  static const String customerProfile = '/customer/profile'; // tab "Thong tin"

  /// KHONG con la tab rieng (Figma chi co 5 tab, khong co Vi). Se la route
  /// PUSH tu ben trong man Profile (`/customer/profile`) o Sprint 5 -
  /// vi du: `context.push('${RoutePaths.customerProfile}/wallet')`.
  static const String customerWallet = '/customer/profile/wallet';

  // ----- Partner Shell (Owner/Manager/Receptionist/Staff) -----
  // 5 tab duoi CO CHU Y - doi chieu tu sidebar Web Admin (vai tro "ADMIN-1234"
  // = Owner cua 1 tiem, KHONG phai "SUPER ADMIN" toan he thong):
  // - Dashboard: gom ca "Quan ly lich hen" (rut gon) va "Bao cao & Thong ke"
  //   (rut gon) cua WEB, vi bottom nav mobile chi co 5 cho, khong tach tab rieng.
  // - Nhan su, Dich vu: map 1-1 voi "Quan ly nhan su" / "Quan ly dich vu & gia" ben Web.
  // - Cac muc it dung (Voucher, Thanh toan, Bao mat, Ho tro) DON vao menu con
  //   trong tab "Ca nhan" thay vi lam tab rieng - xem cac path *_profile* ben duoi.
  // KHONG dua vao app: "Quan ly Nguoi dung" toan he thong, "Cau hinh he thong",
  // "Quan ly Tiem" (duyet dang ky tiem moi, nhieu tiem) - day la dac quyen
  // CHI Super Admin co, thuoc pham vi Web Admin, khong lien quan Owner 1 tiem.
  static const String partnerRoot = '/partner';
  static const String partnerDashboard = '/partner/dashboard';
  static const String partnerSchedule = '/partner/schedule';
  static const String partnerStaff = '/partner/staff';
  static const String partnerServices = '/partner/services';
  static const String partnerProfile = '/partner/profile';

  // ----- Menu con trong tab "Ca nhan" cua Partner (push tu partnerProfile) -----
  /// Xem/tao voucher DON GIAN cho tiem minh - KHONG co "Phan tich chien dich"
  /// nang cao (dac quyen Super Admin, chi co ben Web Admin).
  static const String partnerVouchers = '/partner/profile/vouchers';

  /// Chi xem trang thai doi soat/thanh toan cua tiem minh - KHONG co
  /// "Payment gateway config" (dac quyen Super Admin, chi co ben Web Admin).
  static const String partnerPayments = '/partner/profile/payments';

  /// Doi mat khau, lich su dang nhap cua TAI KHOAN CA NHAN - KHONG co
  /// "Compliance reports" toan he thong (chi co ben Web Admin).
  static const String partnerSecurity = '/partner/profile/security';

  static const String partnerSupport = '/partner/profile/support';
}