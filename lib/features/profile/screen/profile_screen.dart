import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/profile/widget/edit_full_name_dialog.dart';

/// Man goc cua tab "Thong tin" - xem/sua ho so co ban, menu dieu huong toi
/// cac chuc nang phu (Vi, Bao mat, Ho tro...), Dang xuat.
///
/// Sprint 4 CHI ho tro sua ho ten. Cac muc "Vi & Uu dai"/"Bao mat"/"Ho tro"
/// hien la placeholder (`_showComingSoon`) - se noi that o Sprint 5/7/8
/// theo dung ke hoach IA da thong nhat (xem `route_paths.dart` phan Ca nhan).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature sẽ có ở Sprint tiếp theo')));
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
            child: const Text('Đăng xuất', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(authControllerProvider.notifier).signOut();
      // Khong can tu dieu huong - route_guard.dart se tu dua ve Login khi
      // AuthState chuyen sang AuthUnauthenticated.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final UserSession? session = authState is AuthAuthenticated ? authState.session : null;

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
                  child: Icon(Icons.person, size: 28, color: AppColors.textSecondary),
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
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                  onPressed: session == null
                      ? null
                      : () => showEditFullNameDialog(context, currentFullName: session.fullName),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _ProfileMenuItem(
            icon: Icons.card_giftcard_outlined,
            title: 'Ví & Ưu đãi',
            onTap: () => _showComingSoon(context, 'Ví & Ưu đãi'),
          ),
          _ProfileMenuItem(
            icon: Icons.lock_outline,
            title: 'Bảo mật tài khoản',
            onTap: () => _showComingSoon(context, 'Bảo mật tài khoản'),
          ),
          _ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Hỗ trợ',
            onTap: () => _showComingSoon(context, 'Hỗ trợ'),
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
              const Icon(Icons.chevron_right, color: AppColors.textDisabled, size: 20),
          ],
        ),
      ),
    );
  }
}