import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_status_badge.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// TopAppBar rieng cho man Chi tiet Tiem - dung Header variant 4 trong
/// Figma: back + ten tiem + badge trang thai + nut yeu thich. KHONG dua vao
/// `BrandedAppBar` dung chung (xem doc comment trong file do) vi day la UI
/// gan chat voi du lieu 1 Tiem cu the, khong phai AppBar thuong hieu chung.
class ShopDetailAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ShopDetailAppBar({required this.shop, super.key});

  final ShopModel shop;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ShopDetailAppBar> createState() => _ShopDetailAppBarState();
}

class _ShopDetailAppBarState extends State<ShopDetailAppBar> {
  // TAM THOI luu cuc bo, CHUA luu vao Database - se hoan thien khi co bang
  // `favorites` rieng (Sprint 5, cung luc voi Vi Voucher). Gia tri se mat
  // khi thoat man - KHONG danh lua nguoi dung rang da luu vinh vien.
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.shop.name,
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          ShopStatusBadge(isOpen: widget.shop.isOpen),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primary,
          ),
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
        ),
      ],
    );
  }
}