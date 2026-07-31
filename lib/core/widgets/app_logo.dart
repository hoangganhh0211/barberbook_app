import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';

/// Logo thuong hieu BarberBook: icon keo trong khung vuong bo goc mau cam +
/// chu "BarberBook" in nghieng. Dung lai o [SplashScreen] (size lon, co
/// tagline) va `BrandedAppBar` (size nho, khong tagline) - KHONG tu ve lai
/// logo rieng le o tung noi.
class AppLogo extends StatelessWidget {
  const AppLogo({
    this.iconBoxSize = 32,
    this.titleFontSize = 20,
    this.showTagline = false,
    super.key,
  });

  /// Kich thuoc khung vuong chua icon keo - Splash dung to hon (vd: 64),
  /// TopAppBar dung nho (vd: 28-32).
  final double iconBoxSize;
  final double titleFontSize;

  /// Chi Splash Screen hien tagline "Nen tang dat lich cat toc thong minh"
  /// (theo dung noi dung trong Figma) - TopAppBar khong hien de tiet kiem
  /// khong gian.
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(iconBoxSize * 0.28),
              ),
              child: Icon(
                Icons.content_cut_rounded,
                color: AppColors.onPrimary,
                size: iconBoxSize * 0.58,
              ),
            ),
            SizedBox(width: iconBoxSize * 0.35),
            Text('BarberBook', style: AppTextStyles.brandTitle(fontSize: titleFontSize)),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 8),
          Text(
            'Nền tảng đặt lịch cắt tóc thông minh',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
