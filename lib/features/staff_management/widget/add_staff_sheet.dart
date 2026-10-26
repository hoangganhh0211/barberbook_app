import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/staff_management/provider/staff_management_provider.dart';

Future<bool?> showAddStaffSheet(BuildContext context, {required String shopId}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _AddStaffSheetContent(shopId: shopId),
  );
}

class _AddStaffSheetContent extends ConsumerStatefulWidget {
  const _AddStaffSheetContent({required this.shopId});

  final String shopId;

  @override
  ConsumerState<_AddStaffSheetContent> createState() => _AddStaffSheetContentState();
}

class _AddStaffSheetContentState extends ConsumerState<_AddStaffSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final String bio = _bioController.text.trim();
    final result = await ref.read(staffManagementRepositoryProvider).createStaff(
          shopId: widget.shopId,
          fullName: _nameController.text.trim(),
          bio: bio.isEmpty ? null : bio,
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (result) {
      case Success():
        ref.invalidate(shopStaffListProvider(widget.shopId));
        if (context.mounted) Navigator.of(context).pop(true);
      case ResultFailure(:final failure):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Thêm thợ mới', style: AppTextStyles.heading2, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: 'Họ và tên',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: Validators.fullName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Giới thiệu ngắn (không bắt buộc)...',
              ),
            ),
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: 'Thêm thợ',
              isLoading: _isSubmitting,
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}