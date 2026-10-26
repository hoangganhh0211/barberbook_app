import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/validators.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/staff_management/provider/staff_management_provider.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

class EditStaffScreen extends ConsumerStatefulWidget {
  const EditStaffScreen({required this.staff, super.key});

  final StaffModel staff;

  @override
  ConsumerState<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends ConsumerState<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _linkFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  final _phoneController = TextEditingController();
  late bool _isActive;
  late bool _isLinked;
  String? _pending;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff.fullName);
    _bioController = TextEditingController(text: widget.staff.bio ?? '');
    _isActive = widget.staff.isActive;
    _isLinked = widget.staff.profileId != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  bool _allows(AppPermission permission) {
    final AuthState authState = ref.read(authControllerProvider);
    if (authState is! AuthAuthenticated) return false;
    return RbacMatrix.allows(authState.session.role, permission);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
  }

  Future<void> _handleSave() async {
    if (!_allows(AppPermission.staffUpdate) || _pending != null) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _pending = 'save');
    final String bio = _bioController.text.trim();
    final failure = await ref.read(staffManagementRepositoryProvider).updateStaff(
          staffId: widget.staff.id,
          fullName: _nameController.text.trim(),
          bio: bio.isEmpty ? null : bio,
          isActive: _isActive,
        );

    if (!mounted) return;
    setState(() => _pending = null);

    if (failure == null) {
      ref.invalidate(shopStaffListProvider(widget.staff.shopId));
      context.pop('updated');
    } else {
      _showError(failure.message);
    }
  }

  Future<void> _handleLink() async {
    if (!_allows(AppPermission.staffLink) || _pending != null) return;
    if (!_linkFormKey.currentState!.validate()) return;

    setState(() => _pending = 'link');
    final failure = await ref.read(staffManagementRepositoryProvider).linkStaffToProfile(
          staffId: widget.staff.id,
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _pending = null);

    if (failure == null) {
      ref.invalidate(shopStaffListProvider(widget.staff.shopId));
      setState(() => _isLinked = true);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đã gán tài khoản')));
    } else {
      _showError(failure.message);
    }
  }

  Future<void> _handleUnlink() async {
    if (!_allows(AppPermission.staffLink) || _pending != null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Huỷ gán tài khoản'),
        content: const Text('Thợ này sẽ không còn gắn với tài khoản đã chọn.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Huỷ gán', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _pending = 'unlink');
    final failure =
        await ref.read(staffManagementRepositoryProvider).unlinkStaffProfile(widget.staff.id);

    if (!mounted) return;
    setState(() => _pending = null);

    if (failure == null) {
      ref.invalidate(shopStaffListProvider(widget.staff.shopId));
      setState(() {
        _isLinked = false;
        _phoneController.clear();
      });
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đã huỷ gán tài khoản')));
    } else {
      _showError(failure.message);
    }
  }

  Future<void> _handleDelete() async {
    if (!_allows(AppPermission.staffDelete) || _pending != null) return;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xoá nhân sự'),
        content: Text('Xoá "${widget.staff.fullName}" khỏi tiệm? Thao tác này không hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Xoá', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _pending = 'delete');
    final failure = await ref.read(staffManagementRepositoryProvider).deleteStaff(widget.staff.id);

    if (!mounted) return;
    setState(() => _pending = null);

    if (failure == null) {
      ref.invalidate(shopStaffListProvider(widget.staff.shopId));
      context.pop('deleted');
    } else {
      _showError(failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserRole? role = switch (ref.watch(authControllerProvider)) {
      AuthAuthenticated(:final session) => session.role,
      _ => null,
    };
    final bool canView = role != null && RbacMatrix.allows(role, AppPermission.staffView);
    final bool canUpdate = role != null && RbacMatrix.allows(role, AppPermission.staffUpdate);
    final bool canLink = role != null && RbacMatrix.allows(role, AppPermission.staffLink);
    final bool canDelete = role != null && RbacMatrix.allows(role, AppPermission.staffDelete);
    final bool isBusy = _pending != null;

    if (!canView) {
      return const Scaffold(
        appBar: BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
        body: EmptyStateWidget(
          icon: Icons.lock_outline,
          title: 'Bạn không có quyền quản lý nhân sự',
          description: 'Chỉ chủ tiệm mới xem và sửa được hồ sơ thợ.',
        ),
      );
    }

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 24),
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  readOnly: !canUpdate,
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
                  readOnly: !canUpdate,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Giới thiệu ngắn (không bắt buộc)...',
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Đang làm việc', style: AppTextStyles.titleMedium),
                  subtitle: Text(
                    _isActive
                        ? 'Khách có thể chọn thợ này khi đặt lịch'
                        : 'Tạm ngưng, không nhận lịch mới',
                    style: AppTextStyles.bodySecondary,
                  ),
                  value: _isActive,
                  onChanged: !canUpdate || isBusy
                      ? null
                      : (bool value) => setState(() => _isActive = value),
                ),
                if (canUpdate) ...[
                  const SizedBox(height: 8),
                  AppPrimaryButton(
                    label: 'Lưu thay đổi',
                    isLoading: _pending == 'save',
                    onPressed: isBusy ? null : _handleSave,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text('Tài khoản', style: AppTextStyles.titleMedium),
          const SizedBox(height: 10),
          _AccountSection(
            isLinked: _isLinked,
            canLink: canLink,
            isBusy: isBusy,
            isLinking: _pending == 'link',
            linkFormKey: _linkFormKey,
            phoneController: _phoneController,
            onLink: _handleLink,
            onUnlink: _handleUnlink,
          ),
          if (canDelete) ...[
            const SizedBox(height: 28),
            OutlinedButton(
              onPressed: isBusy ? null : _handleDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              child: const Text('Xoá thợ'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccountSection extends StatelessWidget {
  const _AccountSection({
    required this.isLinked,
    required this.canLink,
    required this.isBusy,
    required this.isLinking,
    required this.linkFormKey,
    required this.phoneController,
    required this.onLink,
    required this.onUnlink,
  });

  final bool isLinked;
  final bool canLink;
  final bool isBusy;
  final bool isLinking;
  final GlobalKey<FormState> linkFormKey;
  final TextEditingController phoneController;
  final VoidCallback onLink;
  final VoidCallback onUnlink;

  @override
  Widget build(BuildContext context) {
    if (isLinked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.verified_outlined, color: AppColors.success),
            const SizedBox(width: 10),
            Expanded(child: Text('Đã gán tài khoản', style: AppTextStyles.bodyRegular)),
            if (canLink)
              TextButton(
                onPressed: isBusy ? null : onUnlink,
                child: const Text('Huỷ gán'),
              ),
          ],
        ),
      );
    }

    if (!canLink) {
      return Text('Chưa gán tài khoản', style: AppTextStyles.bodySecondary);
    }

    return Form(
      key: linkFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Số điện thoại đã đăng ký',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            validator: Validators.phone,
            onFieldSubmitted: (_) => onLink(),
          ),
          const SizedBox(height: 12),
          AppPrimaryButton(
            label: 'Gán tài khoản',
            isLoading: isLinking,
            onPressed: isBusy ? null : onLink,
          ),
        ],
      ),
    );
  }
}