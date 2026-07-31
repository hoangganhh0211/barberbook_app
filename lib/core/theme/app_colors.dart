import 'package:flutter/material.dart';

/// Bang mau tap trung cua app - DARK UI (theo dung mau Figma cung cap
/// ngay 29/07/2026: nen navy dam, accent cam, logo "BarberBook" in nghieng).
///
/// - Cac mau `success/warning/error` van giu DUNG theo tai lieu dac ta
///   (muc 2.1 "Bang phan loai thong bao", muc 4.2.3 "Highlight Field loi") -
///   KHONG doi, du tone gan giong mau brand.
/// - `primary` la mau cam thuong hieu, lay tu logo/active-tab trong Figma.
///   Co gia tri RIENG voi `warning` (du nhin gan giong) de tranh 1 ma mau
///   dung cho 2 y nghia khac nhau (thuong hieu vs trang thai canh bao).
/// - Moi noi trong app PHAI tham chieu qua `AppColors`, KHONG hardcode
///   `Color(0x...)` truc tiep trong Widget - khi Figma cap nhat token, chi
///   sua duy nhat o file nay.
abstract class AppColors {
  // ---- Brand (chinh thuc, theo Figma) ----
  static const Color primary = Color(0xFFF97316); // cam logo/active-tab
  static const Color primaryDark = Color(0xFFC2410C);
  static const Color secondary = Color(0xFF111827); // den/graphite (giu cho cac noi can tuong phan manh)

  // ---- Semantic - DUNG THEO TAI LIEU (khong doi) ----
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ---- Dark surface levels -----
  // background: nen tong the (Scaffold). surface: AppBar/BottomNav/Card -
  // sang hon background 1 chut de tao chieu sau, dung theo dung Figma.
  static const Color background = Color(0xFF0B1220);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1A2436); // card noi bat hon (vd: The Heritage Guild header)
  static const Color border = Color(0xFF263148);

  // ---- Text (tren nen toi) ----
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  /// Mau chu/icon hien tren nen `primary` (vd: icon active trong Bottom Nav
  /// dang tren pill mau cam) - can du dam de tuong phan, KHONG dung trang.
  static const Color onPrimary = Color(0xFF1E1206);

  // ---- Status badge (theo bang RBAC / Staff status trong tai lieu) ----
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusOnLeave = Color(0xFFF59E0B);
  static const Color statusInactive = Color(0xFF94A3B8);
  static const Color statusTerminated = Color(0xFFEF4444);
}
