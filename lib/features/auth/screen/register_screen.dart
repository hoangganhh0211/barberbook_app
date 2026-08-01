import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/auth/screen/otp_screen.dart';
import 'package:barberbook_app/routes/route_paths.dart';

/// Man Dang ky - Buoc 1/2 cua luong US-AUTH-001 (Buoc 2 la [OtpScreen]).
///
/// Thu thap Ho ten + SDT + Mat khau, goi API yeu cau OTP. THANH CONG o day
/// KHONG nghia la da tao tai khoan - tai khoan chi thuc su duoc tao sau khi
/// xac thuc OTP dung ([OtpScreen]) - vi vay man nay CHUA luu gi vao
/// AuthState, chi push sang OtpScreen kem theo du lieu can thiet.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final String phone = _phoneController.text.trim();
    final String fullName = _fullNameController.text.trim();
    final String password = _passwordController.text;

    final failure = await ref.read(authControllerProvider.notifier).requestRegisterOtp(
          phone: phone,
          fullName: fullName,
          password: password,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (failure == null) {
      // Chuyen sang man OTP kem theo du lieu can de xac thuc/gui lai ma -
      // KHONG luu gi vao AuthState o day (xem doc comment dau file).
      context.push(
        RoutePaths.registerOtp,
        extra: OtpScreenArgs(phone: phone, fullName: fullName, password: password),
      );
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandedAppBar(
        variant: BrandedAppBarVariant.titleOnly,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tạo tài khoản mới', style: AppTextStyles.heading2),
                const SizedBox(height: 6),
                Text(
                  'Chỉ mất chưa đến 1 phút để bắt đầu đặt lịch cắt tóc',
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 28),

                Text('Họ và tên', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  decoration: const InputDecoration(
                    hintText: 'Nguyễn Văn A',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 20),

                Text('Số điện thoại', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
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
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Tối thiểu 6 ký tự',
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
                const SizedBox(height: 20),

                Text('Xác nhận mật khẩu', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleSubmit(),
                  decoration: const InputDecoration(
                    hintText: 'Nhập lại mật khẩu',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) => Validators.confirmPassword(_passwordController.text)(value),
                ),
                const SizedBox(height: 32),

                AppPrimaryButton(
                  label: 'Nhận mã OTP',
                  isLoading: _isSubmitting,
                  onPressed: _handleSubmit,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Đã có tài khoản? ', style: AppTextStyles.bodySecondary),
                    TextButton(
                      onPressed: _isSubmitting ? null : () => context.pop(),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: const Text('Đăng nhập'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}