import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';

/// Cac TextStyle dat ten theo muc dich su dung (khong dat theo size) de khi
/// doi font/scale toan he thong chi can sua o day.
///
/// `fontFamily` de null (dung font mac dinh cua OS) cho den khi file font
/// `Inter` (duoc nhac trong tai lieu, muc Empty State) duoc them vao
/// `assets/fonts/` va khai bao trong `pubspec.yaml` (dang comment san).
abstract class AppTextStyles {
  static const String? _fontFamily = null; // doi thanh 'Inter' khi co font asset

  static const TextStyle heading1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Dung cho tieu de "Chua co du lieu" trong Empty State (muc 3.2.2).
  static const TextStyle emptyStateTitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Dung cho error message duoi input (muc 4.2.3), toi da 2 dong.
  static const TextStyle fieldError = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
  );

  /// Chu "BarberBook" in nghieng mau cam - dung trong `AppLogo` va
  /// `BrandedAppBar`. Tham so [fontSize] de logo tren Splash (to hon) va
  /// tren TopAppBar (nho hon) dung chung 1 style, chi doi size.
  static TextStyle brandTitle({double fontSize = 20}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        color: AppColors.primary,
      );
}
