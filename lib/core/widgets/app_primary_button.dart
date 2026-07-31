import 'package:flutter/material.dart';

/// Nut hanh dong chinh (Luu/Xac nhan/Dang nhap...) co san logic Loading.
///
/// Dung theo dung yeu cau muc 3.1: "Luu/Xac nhan: Chay Validation -> Gui
/// API -> Loading -> Xu ly Response" va "Disabled khi isSubmitting" -
/// nen KHONG duoc phep tu viet lai ElevatedButton + CircularProgressIndicator
/// rieng le o tung man hinh, tranh quen disable khi dang submit.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;

  /// Truyen null de disable nut (vd: form chua hop le).
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null;

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
                Text(label),
              ],
            ),
    );
  }
}
