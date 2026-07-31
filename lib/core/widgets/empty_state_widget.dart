import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';

/// Empty State dung chung, tuan thu cau truc bat buoc trong tai lieu
/// (muc 3.2.2): Icon -> "Chua co du lieu" -> mo ta ngan -> CTA dieu huong.
///
/// KHONG duoc hien thi widget nay trong luc dang loading (spec noi ro:
/// "Khong hien thi Empty State trong luc dang loading") - trach nhiem nay
/// thuoc ve noi goi (dung [AsyncValueWidget] de dieu phoi dung thu tu).
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    this.icon = Icons.inbox_outlined,
    this.description,
    this.ctaLabel,
    this.onCtaPressed,
    super.key,
  });

  final String title;
  final IconData icon;
  final String? description;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.textDisabled),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(
                description!,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onCtaPressed,
                child: Text(ctaLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
