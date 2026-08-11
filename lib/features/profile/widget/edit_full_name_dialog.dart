import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/profile/provider/profile_provider.dart';
Future<void> showEditFullNameDialog(BuildContext context, {required String currentFullName}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _EditFullNameDialog(currentFullName: currentFullName),
  );
}

class _EditFullNameDialog extends ConsumerStatefulWidget {
  const _EditFullNameDialog({required this.currentFullName});

  final String currentFullName;

  @override
  ConsumerState<_EditFullNameDialog> createState() => _EditFullNameDialogState();
}

class _EditFullNameDialogState extends ConsumerState<_EditFullNameDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentFullName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final failure = await ref
        .read(profileRepositoryProvider)
        .updateFullName(_controller.text.trim());

    if (!mounted) return;

    if (failure == null) {
      await ref.read(authControllerProvider.notifier).refreshSession();
      if (context.mounted) Navigator.of(context).pop();
    } else {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chỉnh sửa họ tên'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'Họ và tên'),
          validator: Validators.fullName,
          onFieldSubmitted: (_) => _handleSave(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Huỷ'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSave,
          style: ElevatedButton.styleFrom(minimumSize: const Size(64, 36)),
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                )
              : const Text('Lưu'),
        ),
      ],
    );
  }
}