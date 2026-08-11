import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/widgets/app_logo.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AppLogo(iconBoxSize: 64, titleFontSize: 26, showTagline: true),
      ),
    );
  }
}
