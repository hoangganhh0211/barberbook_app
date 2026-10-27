import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/profile/widget/edit_full_name_dialog.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_status_badge.dart';
import 'package:barberbook_app/features/staff_schedule/provider/staff_schedule_provider.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

class PartnerProfileScreen extends ConsumerWidget {
  const PartnerProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
          const SnackBar(content: Text('Tính năng đang phát triển.')));
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi tài khoản này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Đăng xuất',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final UserSession? session =
        authState is AuthAuthenticated ? authState.session : null;

    return Scaffold(
      appBar: const BrandedAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.background,
                  child: Icon(Icons.person,
                      size: 28, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session?.fullName ?? '—',
                        style: AppTextStyles.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session?.phone ?? '',
                        style: AppTextStyles.bodySecondary,
                      ),
                      if (session != null) ...[
                        const SizedBox(height: 8),
                        _RoleChip(role: session.role),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon:
                      const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: session == null
                      ? null
                      : () => showEditFullNameDialog(context,
                          currentFullName: session.fullName),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Bảo mật tài khoản',
            onTap: () => _showComingSoon(context),
          ),
          _ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Hỗ trợ',
            onTap: () => _showComingSoon(context),
          ),
          _ProfileMenuItem(
            icon: Icons.info_outline,
            title: 'Về BarberBook',
            trailing: Text('v0.1.0', style: AppTextStyles.caption),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'BarberBook',
              applicationVersion: '0.1.0',
            ),
          ),
          const SizedBox(height: 20),
          _ProfileMenuItem(
            icon: Icons.logout,
            title: 'Đăng xuất',
            iconColor: AppColors.error,
            titleColor: AppColors.error,
            onTap: () => _handleSignOut(context, ref),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role});

  final UserRole role;

  String get _label {
    return switch (role) {
      UserRole.owner => 'Chủ tiệm',
      UserRole.staff => 'Thợ',
      UserRole.customer => 'Khách',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: AppTextStyles.caption
            .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _PartnerShopSection extends ConsumerWidget {
  const _PartnerShopSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ShopModel?> ownedAsync = ref.watch(myOwnedShopProvider);

    return ownedAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (shop) {
        if (shop != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _ShopCard(shop: shop, caption: 'Tiệm của bạn'),
          );
        }
        return const _LinkedShopSection();
      },
    );
  }
}

class _LinkedShopSection extends ConsumerWidget {
  const _LinkedShopSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<({String id, String shopId})?> staffAsync =
        ref.watch(myStaffInfoProvider);

    return staffAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (info) {
        if (info == null) return const SizedBox.shrink();
        return _ShopById(shopId: info.shopId);
      },
    );
  }
}

class _ShopById extends ConsumerWidget {
  const _ShopById({required this.shopId});

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ShopModel> shopAsync =
        ref.watch(shopDetailProvider(shopId));

    return shopAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (shop) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _ShopCard(shop: shop, caption: 'Tiệm đang làm'),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  const _ShopCard({required this.shop, required this.caption});

  final ShopModel shop;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(caption, style: AppTextStyles.caption),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      shop.name,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ShopStatusBadge(isOpen: shop.isOpen),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      shop.address,
                      style: AppTextStyles.bodySecondary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (shop.phone != null && shop.phone!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(shop.phone!, style: AppTextStyles.bodySecondary),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyRegular.copyWith(color: titleColor),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailing == null)
              const Icon(Icons.chevron_right,
                  color: AppColors.textDisabled, size: 20),
          ],
        ),
      ),
    );
  }
}
