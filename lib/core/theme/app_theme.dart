import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';

/// ThemeData Material 3 tap trung.
///
/// LUU Y: thuong hieu BarberBook (theo Figma) hien CHI co 1 theme Dark -
/// chua co yeu cau Light Mode. Vi vay chi cung cap `AppTheme.dark`. Neu
/// sau nay can Light Mode (vd: yeu cau Accessibility), them `AppTheme.light`
/// song song va bo sung `themeMode`/toggle trong `app.dart` - khong sua
/// theme nay theo huong "doan truoc".
///
/// `app.dart` CHI goi `AppTheme.dark` - khong noi nao khac duoc phep tu
/// tao ThemeData rieng, tranh UI khong dong bo.
abstract class AppTheme {
  static ThemeData get dark {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      error: AppColors.error,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.titleMedium,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      textTheme: const TextTheme(
        headlineMedium: AppTextStyles.heading1,
        headlineSmall: AppTextStyles.heading2,
        titleMedium: AppTextStyles.titleMedium,
        bodyMedium: AppTextStyles.bodyRegular,
        bodySmall: AppTextStyles.bodySecondary,
        labelSmall: AppTextStyles.caption,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        // Vien do khi loi - dung theo muc 4.2.3 "Vien do #EF4444 bao quanh input".
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        errorStyle: AppTextStyles.fieldError,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // CHI DINH RO backgroundColor - KHONG de mac dinh lay tu
          // `colorScheme.primary`. Ly do: `ColorScheme.fromSeed()` (dung o
          // tren) tu tinh toan lai 1 tong mau "primary" theo thuat toan
          // Material 3 (uu tien do tuong phan/hai hoa tong the), KHONG giu
          // nguyen chinh xac gia tri seed - dan tren Dark Mode ra 1 mau nau
          // xin thay vi cam thuong hieu that (#F97316), khien nut bam gan
          // nhu "mat chu" vi ca nen lan chu deu toi.
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.35),
          disabledForegroundColor: AppColors.onPrimary.withOpacity(0.6),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTextStyles.titleMedium.copyWith(color: AppColors.onPrimary),
          foregroundColor: AppColors.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // Cung ly do voi elevatedButtonTheme o tren - chi dinh ro thay vi
          // de mac dinh lay tu `colorScheme.primary`.
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // Dung cho widget `NavigationBar` (Material 3) dang dung trong
      // CustomerShellScreen/PartnerShellScreen - KHONG phai
      // `BottomNavigationBar` (widget Material 2 cu). `indicatorColor` chinh
      // la "pill" mau cam bao quanh icon dang active trong Figma; icon/label
      // tren pill do dung mau `onPrimary` (dam) de du tuong phan, tranh
      // trang hop trang-tren-cam kho doc.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.onPrimary : AppColors.textSecondary,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final bool selected = states.contains(WidgetState.selected);
          return AppTextStyles.caption.copyWith(
            color: selected ? AppColors.onPrimary : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          );
        }),
      ),
    );
  }
}