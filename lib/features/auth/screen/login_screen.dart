import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/core/widgets/app_logo.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';

/// Man dang nhap (US-AUTH-001) - SDT + Mat khau, dung theo luong chuan
/// muc 3.1 trong tai lieu: "Chay Validation -> Gui API -> Loading -> Xu ly
/// Response".
///
/// KHONG tu dieu huong sang Home/Dashboard khi dang nhap thanh cong -
/// `route_guard.dart` se tu dong lam viec do ngay khi [AuthController] doi
/// state sang [AuthAuthenticated] (xem `RouterRefreshNotifier`). Man hinh
/// nay chi co trach nhiem: thu thap input, goi Controller, hien thi loi.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 1. Validation - dung FormState co san, khong tu viet lai kiem tra rong/dinh dang.
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // 2. Goi API (qua Controller -> Repository -> Service) + 3. Loading da
    // duoc phan anh qua `_isSubmitting` (AppPrimaryButton tu disable+quay).
    final Failure? failure = await ref.read(authControllerProvider.notifier).loginWithPhonePassword(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // 4. Xu ly Response: chi can xu ly truong hop LOI o day - truong hop
    // thanh cong da duoc route_guard.dart tu dong dieu huong.
    if (failure != null) {
      _showErrorSnackBar(failure.message);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$feature sẽ có ở Sprint tiếp theo')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppLogo(iconBoxSize: 56, titleFontSize: 24)),
                const SizedBox(height: 12),
                Text(
                  'Đăng nhập để tiếp tục đặt lịch cắt tóc',
                  style: AppTextStyles.bodySecondary,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),

                Text('Số điện thoại', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  style: AppTextStyles.bodyRegular,
                  decoration: const InputDecoration(
                    hintText: '0912 345 678',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  validator: Validators.phone,
                ),
                const SizedBox(height: 20),

                Text('Mật khẩu', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  style: AppTextStyles.bodyRegular,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _handleLogin(),
                  decoration: InputDecoration(
                    hintText: 'Nhập mật khẩu',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: Validators.password,
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isSubmitting ? null : () => _showComingSoon('Quên mật khẩu'),
                    child: const Text('Quên mật khẩu?'),
                  ),
                ),
                const SizedBox(height: 8),

                AppPrimaryButton(
                  label: 'Đăng nhập',
                  isLoading: _isSubmitting,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 28),

                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('hoặc', style: AppTextStyles.caption),
                    ),
                    const Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                const SizedBox(height: 24),

                // Nut Google/Facebook: UI da san theo dung Figma, nhung
                // CHUA wiring that (can them package `google_sign_in`,
                // `flutter_facebook_auth` va API `ApiEndpoints.socialLogin`
                // - se hoan thien cung phan con lai cua Sprint 1).
                OutlinedButton(
                  onPressed: _isSubmitting ? null : () => _showComingSoon('Đăng nhập Google'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Text('G', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
                      ),
                      const SizedBox(width: 10),
                      const Text('Tiếp tục với Google'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : () => _showComingSoon('Đăng nhập Facebook'),
                  icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                  label: const Text('Tiếp tục với Facebook'),
                ),
                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Chưa có tài khoản? ', style: AppTextStyles.bodySecondary),
                    TextButton(
                      onPressed: _isSubmitting ? null : () => _showComingSoon('Đăng ký'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: const Text('Đăng ký ngay'),
                    ),
                  ],
                ),

                if (kDebugMode) ...[
                  const SizedBox(height: 40),
                  const _DebugRoleSwitcher(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// CHI hien trong `kDebugMode` (khong bao gio xuat hien trong build release
/// tren Google Play/App Store) - dung de QA/dev test nhanh Role-based
/// routing khi backend that chua san sang, KHONG thay the luong dang nhap
/// that o tren.
class _DebugRoleSwitcher extends ConsumerWidget {
  const _DebugRoleSwitcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.warning),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('DEBUG ONLY - bỏ qua backend', style: AppTextStyles.caption.copyWith(color: AppColors.warning)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => ref.read(authControllerProvider.notifier).debugSignInAs(UserRole.customer),
            child: const Text('Vào với vai trò Khách hàng'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => ref.read(authControllerProvider.notifier).debugSignInAs(UserRole.owner),
            child: const Text('Vào với vai trò Owner'),
          ),
        ],
      ),
    );
  }
}
