import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/app_logo.dart';

/// 2 bien the TopAppBar chung theo dung Figma:
/// - [BrandedAppBarVariant.logoCentered]: logo (icon+chu) can giua - dung
///   cho man goc cua moi Shell (Home Customer/Partner Dashboard...).
/// - [BrandedAppBarVariant.titleOnly]: chi chu "BarberBook" in nghieng, can
///   trai canh nut back - dung cho cac man con don gian (vd: man Dieu
///   khoan, Chinh sach...).
///
/// Bien the thu 4 trong Figma (co badge "Mo cua" + nut yeu thich) la AppBar
/// RIENG cua man Chi tiet Tiem, se tao o Sprint 2 (`shop_detail_app_bar.dart`),
/// KHONG dua vao day de tranh widget nay "gong minh" nhieu use-case khac nhau.
enum BrandedAppBarVariant { logoCentered, titleOnly }

class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandedAppBar({
    this.variant = BrandedAppBarVariant.logoCentered,
    this.showBackButton = false,
    this.actions,
    super.key,
  });

  final BrandedAppBarVariant variant;
  final bool showBackButton;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isCentered = variant == BrandedAppBarVariant.logoCentered;

    return AppBar(
      automaticallyImplyLeading: showBackButton,
      centerTitle: isCentered,
      iconTheme: const IconThemeData(color: AppColors.primary),
      title: isCentered
          ? const AppLogo(iconBoxSize: 28, titleFontSize: 18)
          : Text('BarberBook', style: AppTextStyles.brandTitle(fontSize: 18)),
      actions: actions,
    );
  }
}
