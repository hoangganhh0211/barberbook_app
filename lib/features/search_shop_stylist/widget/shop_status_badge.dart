import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';

/// Badge trang thai Mo cua/Dong cua - dung chung o [ShopListItem] (tab
/// Tiem) va `ShopDetailAppBar` (man Chi tiet Tiem).
class ShopStatusBadge extends StatelessWidget {
  const ShopStatusBadge({required this.isOpen, super.key});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final Color color = isOpen ? AppColors.success : AppColors.textDisabled;
    final String label = isOpen ? 'Mở cửa' : 'Đóng cửa';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}