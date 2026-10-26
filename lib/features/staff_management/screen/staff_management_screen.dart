import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/core/widgets/permission_guard.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/staff_management/provider/staff_management_provider.dart';
import 'package:barberbook_app/features/staff_management/widget/add_staff_sheet.dart';
import 'package:barberbook_app/features/staff_management/widget/staff_list_item.dart';
import 'package:barberbook_app/routes/route_paths.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

class StaffManagementScreen extends ConsumerWidget {
  const StaffManagementScreen({super.key});

  Future<void> _handleAddPressed(BuildContext context, String shopId) async {
    final bool? created = await showAddStaffSheet(context, shopId: shopId);
    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Đã thêm thợ mới')));
    }
  }

  Future<void> _handleStaffTap(BuildContext context, WidgetRef ref, StaffModel staff) async {
    final AuthState authState = ref.read(authControllerProvider);
    final bool canUpdate = authState is AuthAuthenticated &&
        RbacMatrix.allows(authState.session.role, AppPermission.staffUpdate);
    if (!canUpdate) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Bạn không có quyền sửa nhân sự')));
      return;
    }

    final String? result = await context.push<String>(
      RoutePaths.partnerStaffEdit,
      extra: staff,
    );
    if (result == null || !context.mounted) return;

    final String message = result == 'deleted' ? 'Đã xoá thợ' : 'Đã cập nhật thông tin thợ';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    if (authState is! AuthAuthenticated ||
        !RbacMatrix.allows(authState.session.role, AppPermission.staffView)) {
      return const Scaffold(
        appBar: BrandedAppBar(),
        body: EmptyStateWidget(
          icon: Icons.lock_outline,
          title: 'Bạn không có quyền quản lý nhân sự',
          description: 'Chỉ chủ tiệm mới thêm, sửa hoặc xoá nhân sự.',
        ),
      );
    }

    final UserRole role = authState.session.role;
    final AsyncValue<ShopModel?> shopAsync = ref.watch(myOwnedShopProvider);
    final ShopModel? shop = shopAsync.maybeWhen(data: (s) => s, orElse: () => null);
    final bool canCreate = RbacMatrix.allows(role, AppPermission.staffCreate);

    return Scaffold(
      appBar: const BrandedAppBar(),
      floatingActionButton: shop == null || !canCreate
          ? null
          : PermissionGuard(
              currentRole: role,
              allowedRoles: RbacMatrix.rolesWith(AppPermission.staffCreate),
              child: FloatingActionButton.extended(
                onPressed: () => _handleAddPressed(context, shop.id),
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Thêm thợ'),
              ),
            ),
      body: shopAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              error is Failure ? error.message : 'Đã có lỗi xảy ra.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular,
            ),
          ),
        ),
        data: (ownedShop) {
          if (ownedShop == null) {
            return const EmptyStateWidget(
              icon: Icons.storefront_outlined,
              title: 'Bạn chưa là chủ của tiệm nào',
              description: 'Chỉ chủ tiệm mới quản lý được danh sách nhân sự.',
            );
          }
          return _StaffList(
            shop: ownedShop,
            onTapStaff: (s) => _handleStaffTap(context, ref, s),
          );
        },
      ),
    );
  }
}

class _StaffList extends ConsumerWidget {
  const _StaffList({required this.shop, required this.onTapStaff});

  final ShopModel shop;
  final void Function(StaffModel staff) onTapStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<StaffModel>> staffAsync = ref.watch(shopStaffListProvider(shop.id));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(shopStaffListProvider(shop.id)),
      child: AsyncValueWidget<List<StaffModel>>(
        value: staffAsync,
        skeletonItemCount: 3,
        isEmpty: (staff) => staff.isEmpty,
        emptyTitle: 'Tiệm chưa có thợ nào',
        emptyDescription: 'Bấm "Thêm thợ" để tạo thợ đầu tiên',
        onRetry: () => ref.invalidate(shopStaffListProvider(shop.id)),
        dataBuilder: (staff) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          itemCount: staff.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => StaffListItem(
            staff: staff[index],
            onTap: () => onTapStaff(staff[index]),
          ),
        ),
      ),
    );
  }
}