import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';

/// Anh cover cua Tiem, dung chung o `ShopListItem` (tab Tiem) va
/// `FeaturedShopCard` (tab Home) - tranh lap logic CachedNetworkImage +
/// placeholder o 2 noi. Tham so hoa kich thuoc/bo goc de linh hoat cho
/// tung layout khac nhau.
class ShopCoverImage extends StatelessWidget {
  const ShopCoverImage({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = Container(
      width: width,
      height: height,
      color: AppColors.background,
      alignment: Alignment.center,
      child: const Icon(Icons.content_cut, color: AppColors.textDisabled),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: imageUrl == null
          ? placeholder
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholder: (_, __) => placeholder,
              errorWidget: (_, __, ___) => placeholder,
            ),
    );
  }
}