import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';

/// Du lieu can truyen tu [RegisterScreen] sang [OtpScreen] qua `extra` cua
/// go_router. KHONG phai domain model (khong dung o Repository/Service) -
/// chi la DTO cho 1 lan dieu huong, nen de o day thay vi thu muc `model/`.
///
/// `password` van can truyen tiep de dung khi "Gui lai ma" - Supabase yeu
/// cau goi lai `signUp()` (voi cung password) de gui lai OTP, KHONG co API
/// "resend" tach rieng cho luong dang ky bang SDT+Password.
class OtpScreenArgs {
  const OtpScreenArgs({
    required this.phone,
    required this.fullName,
    required this.password,
  });

  final String phone;
  final String fullName;
  final String password;
}

/// Man Nhap OTP - Buoc 2/2 cua luong US-AUTH-001. Xac thuc ma OTP + hoan
/// tat tao tai khoan. Thanh cong se tu dong dang nhap (Supabase tra ve
/// session, `AuthController` tu cap nhat state qua `onAuthStateChange`),
/// `route_guard.dart` tu dieu huong vao dung Shell - man nay KHONG tu
/// dieu huong.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({required this.args, super.key});

  final OtpScreenArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  /// Supabase KHONG tra ve thoi gian het han OTP qua API - dung 1 gia tri
  /// co dinh hop ly o client. Neu Backend/Supabase cau hinh khac, chi can
  /// sua so nay, khong anh huong logic con lai.
  static const int _otpValiditySeconds = 60;

  final _otpController = TextEditingController();

  int _remainingSeconds = _otpValiditySeconds;
  Timer? _countdownTimer;

  String _otpCode = '';
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = _otpValiditySeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() => _remainingSeconds = 0);
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
  }

  Future<void> _handleResend() async {
    setState(() => _isResending = true);

    final Failure? failure = await ref.read(authControllerProvider.notifier).resendRegisterOtp(
          phone: widget.args.phone,
          fullName: widget.args.fullName,
          password: widget.args.password,
        );

    if (!mounted) return;
    setState(() => _isResending = false);

    if (failure == null) {
      _otpController.clear();
      setState(() => _otpCode = '');
      _startCountdown();
      _showSnackBar('Đã gửi lại mã OTP', isError: false);
    } else {
      _showSnackBar(failure.message, isError: true);
    }
  }

  Future<void> _handleVerify() async {
    if (_otpCode.length != 6) return;

    setState(() => _isVerifying = true);

    final Failure? failure = await ref.read(authControllerProvider.notifier).verifyRegisterOtp(
          phone: widget.args.phone,
          otpCode: _otpCode,
        );

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (failure != null) {
      _otpController.clear();
      setState(() => _otpCode = '');
      _showSnackBar(failure.message, isError: true);
    }
    // Thanh cong: khong lam gi them - route_guard.dart tu dieu huong.
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.success,
        ),
      );
  }

  String get _formattedCountdown {
    final int minutes = _remainingSeconds ~/ 60;
    final int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool canResend = _remainingSeconds <= 0 && !_isResending;

    return Scaffold(
      appBar: const BrandedAppBar(
        variant: BrandedAppBarVariant.titleOnly,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Xác thực số điện thoại', style: AppTextStyles.heading2),
              const SizedBox(height: 6),
              Text(
                'Nhập mã gồm 6 chữ số vừa được gửi tới số ${widget.args.phone}',
                style: AppTextStyles.bodySecondary,
              ),
              const SizedBox(height: 32),

              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                enableActiveFill: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 52,
                  fieldWidth: 46,
                  activeColor: AppColors.primary,
                  selectedColor: AppColors.primary,
                  inactiveColor: AppColors.border,
                  activeFillColor: AppColors.surface,
                  inactiveFillColor: AppColors.surface,
                  selectedFillColor: AppColors.surface,
                ),
                onChanged: (value) => setState(() => _otpCode = value),
                onCompleted: (_) => _handleVerify(),
              ),
              const SizedBox(height: 24),

              Center(
                child: _remainingSeconds > 0
                    ? Text('Mã hết hạn sau $_formattedCountdown', style: AppTextStyles.bodySecondary)
                    : TextButton(
                        onPressed: canResend ? _handleResend : null,
                        child: Text(_isResending ? 'Đang gửi lại...' : 'Gửi lại mã OTP'),
                      ),
              ),
              const SizedBox(height: 28),

              AppPrimaryButton(
                label: 'Xác nhận',
                isLoading: _isVerifying,
                onPressed: _otpCode.length == 6 ? _handleVerify : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}