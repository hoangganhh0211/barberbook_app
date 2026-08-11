import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/app_logo.dart';


enum BrandedAppBarVariant { logoCentered, titleOnly }

class BrandedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandedAppBar({
    this.variant = BrandedAppBarVariant.logoCentered,
    this.showBackButton = false,
    this.actions,
    this.bottom,
    super.key,
  });

  final BrandedAppBarVariant variant;
  final bool showBackButton;
  final List<Widget>? actions;

  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

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
      bottom: bottom,
    );
  }
}