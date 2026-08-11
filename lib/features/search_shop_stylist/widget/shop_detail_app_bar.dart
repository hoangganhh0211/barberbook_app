import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_status_badge.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';
class ShopDetailAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ShopDetailAppBar({required this.shop, super.key});

  final ShopModel shop;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ShopDetailAppBar> createState() => _ShopDetailAppBarState();
}

class _ShopDetailAppBarState extends State<ShopDetailAppBar> {
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