import 'package:flutter/material.dart';

abstract class AppColors {
  // ---- Brand ---
  static const Color primary = Color(0xFFF97316); // cam logo/active-tab
  static const Color primaryDark = Color(0xFFC2410C);
  static const Color secondary = Color(0xFF111827); // den/graphite (giu cho cac noi can tuong phan manh)

  // ---- Semantic  ----
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ---- Dark surface levels -----
  // background: nen tong the (Scaffold). surface: AppBar/BottomNav/Card -
  static const Color background = Color(0xFF0B1220);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1A2436); // card noi bat hon (vd: The Heritage Guild header)
  static const Color border = Color(0xFF263148);

  // ---- Text (tren nen toi) ----
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);

  /// Mau chu/icon hien tren nen `primary`
  static const Color onPrimary = Color(0xFF1E1206);

  // ---- Status badge  ----
  static const Color statusActive = Color(0xFF10B981);
  static const Color statusOnLeave = Color(0xFFF59E0B);
  static const Color statusInactive = Color(0xFF94A3B8);
  static const Color statusTerminated = Color(0xFFEF4444);
}
