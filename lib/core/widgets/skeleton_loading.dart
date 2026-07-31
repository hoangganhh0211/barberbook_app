import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';

/// Skeleton loading cho Page Load - dung THAY THE cho spinner toan trang,
/// dung theo yeu cau muc 3.2.1: "Skeleton screens thay cho spinner toan
/// trang. Shimmer effect, height match content thuc te."
///
/// Cach dung: truyen vao 1 [itemHeight] va [itemCount] khop voi list item
/// thuc te se hien thi, de tranh "nhay" layout khi data load xong.
class SkeletonLoading extends StatelessWidget {
  const SkeletonLoading({
    required this.itemCount,
    this.itemHeight = 80,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
    super.key,
  });

  final int itemCount;
  final double itemHeight;
  final double spacing;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.background,
      period: const Duration(milliseconds: 1200),
      child: ListView.separated(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(height: spacing),
        itemBuilder: (_, __) => Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
