import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/core/widgets/app_logo.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/routes/route_paths.dart';
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
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    final Failure? failure = await ref.read(authControllerProvider.notifier).loginWithPhonePassword(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Chưa có tài khoản? ', style: AppTextStyles.bodySecondary),
                    TextButton(
                      onPressed: _isSubmitting ? null : () => context.push(RoutePaths.register),
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