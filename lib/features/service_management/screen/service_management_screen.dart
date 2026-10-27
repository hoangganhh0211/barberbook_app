import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/booking/provider/booking_catalog_providers.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/service_management/model/service_admin_item.dart';
import 'package:barberbook_app/features/service_management/provider/service_management_provider.dart';
import 'package:barberbook_app/features/service_management/screen/service_editor_dialog.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

enum _ServiceAction { edit, toggleActive }

class ServiceManagementScreen extends ConsumerWidget {
  const ServiceManagementScreen({super.key});

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    ShopModel shop, {
    ServiceAdminItem? service,
  }) async {
    final AuthState authState = ref.read(authControllerProvider);
    if (authState is! AuthAuthenticated ||
        !RbacMatrix.allows(authState.session.role, service == null
            ? AppPermission.serviceCreate
            : AppPermission.serviceUpdate)) {
      _showMessage(context, 'Bạn không có quyền thực hiện thao tác này.', isError: true);
      return;
    }

    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ServiceEditorDialog(
        service: service,
        onSave: (data) async {
          final serviceApi = ref.read(serviceManagementServiceProvider);
          if (service == null) {
            await serviceApi.createService(shopId: shop.id, data: data);
          } else {
            await serviceApi.updateService(
              shopId: shop.id,
              serviceId: service.id,
              data: data,
            );
          }
        },
      ),
    );

    if (saved != true || !context.mounted) return;
    ref.invalidate(serviceManagementListProvider(shop.id));
    ref.invalidate(serviceListProvider(shop.id));
    _showMessage(context, service == null ? 'Đã thêm dịch vụ.' : 'Đã cập nhật dịch vụ.');
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    ShopModel shop,
    ServiceAdminItem service,
    _ServiceAction action,
  ) async {
    if (action == _ServiceAction.edit) {
      await _openEditor(context, ref, shop, service: service);
      return;
    }

    final AuthState authState = ref.read(authControllerProvider);
    if (authState is! AuthAuthenticated ||
        !RbacMatrix.allows(authState.session.role, AppPermission.serviceToggleActive)) {
      _showMessage(context, 'Bạn không có quyền thay đổi trạng thái dịch vụ.', isError: true);
      return;
    }

    final bool nextActive = !service.isActive;
    if (!nextActive) {
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Ngừng cung cấp dịch vụ?'),
          content: Text(
            '“${service.name}” sẽ không còn xuất hiện trong danh sách để khách đặt lịch. '
            'Lịch hẹn cũ vẫn được giữ nguyên.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Ngừng dịch vụ'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
    }

    try {
      await ref.read(serviceManagementServiceProvider).setServiceActive(
            shopId: shop.id,
            serviceId: service.id,
            isActive: nextActive,
          );
      ref.invalidate(serviceManagementListProvider(shop.id));
      ref.invalidate(serviceListProvider(shop.id));
      if (context.mounted) {
        _showMessage(context, nextActive ? 'Đã kích hoạt dịch vụ.' : 'Đã ngừng cung cấp dịch vụ.');
      }
    } catch (error) {
      if (!context.mounted) return;
      _showMessage(context, _errorText(error), isError: true);
    }
  }

  static void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.success,
        ),
      );
  }

  static String _errorText(Object error) {
    if (error is PostgrestException) return error.message;
    if (error is StateError) return error.message;
    return 'Không thể cập nhật dịch vụ. Vui lòng kiểm tra kết nối và quyền truy cập.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    if (authState is! AuthAuthenticated ||
        !RbacMatrix.allows(authState.session.role, AppPermission.serviceView)) {
      return const Scaffold(
        appBar: BrandedAppBar(),
        body: EmptyStateWidget(
          icon: Icons.lock_outline,
          title: 'Bạn không có quyền quản lý dịch vụ',
          description: 'Chức năng này chỉ dành cho chủ tiệm.',
        ),
      );
    }

    final UserRole role = authState.session.role;
    final AsyncValue<ShopModel?> shopAsync = ref.watch(myOwnedShopProvider);
    final ShopModel? shop = shopAsync.valueOrNull;

    return Scaffold(
      appBar: const BrandedAppBar(),
      floatingActionButton: shop != null && RbacMatrix.allows(role, AppPermission.serviceCreate)
          ? FloatingActionButton.extended(
              onPressed: () => _openEditor(context, ref, shop),
              icon: const Icon(Icons.add),
              label: const Text('Thêm dịch vụ'),
            )
          : null,
      body: shopAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 42, color: AppColors.error),
                const SizedBox(height: 12),
                Text(_errorText(error), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(myOwnedShopProvider),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
        data: (ownedShop) {
          if (ownedShop == null) {
            return const EmptyStateWidget(
              icon: Icons.storefront_outlined,
              title: 'Bạn chưa có tiệm',
              description: 'Hãy liên kết tài khoản với một tiệm trước khi quản lý dịch vụ.',
            );
          }
          return _ServiceList(
            shop: ownedShop,
            onAction: (service, action) =>
                _handleAction(context, ref, ownedShop, service, action),
          );
        },
      ),
    );
  }
}

class _ServiceList extends ConsumerWidget {
  const _ServiceList({required this.shop, required this.onAction});

  final ShopModel shop;
  final Future<void> Function(ServiceAdminItem service, _ServiceAction action) onAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ServiceAdminItem>> servicesAsync =
        ref.watch(serviceManagementListProvider(shop.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(serviceManagementListProvider(shop.id));
        await ref.read(serviceManagementListProvider(shop.id).future);
      },
      child: servicesAsync.when(
        loading: () => ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 180),
            Center(child: CircularProgressIndicator()),
          ],
        ),
        error: (error, _) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.error_outline, size: 44, color: AppColors.error),
            const SizedBox(height: 12),
            Text(ServiceManagementScreen._errorText(error), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton(
                onPressed: () => ref.invalidate(serviceManagementListProvider(shop.id)),
                child: const Text('Tải lại'),
              ),
            ),
          ],
        ),
        data: (services) {
          if (services.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: const [
                SizedBox(height: 70),
                EmptyStateWidget(
                  icon: Icons.content_cut_outlined,
                  title: 'Chưa có dịch vụ nào',
                  description: 'Thêm dịch vụ đầu tiên để khách hàng có thể đặt lịch.',
                ),
              ],
            );
          }

          final int activeCount = services.where((service) => service.isActive).length;
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              Text(shop.name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '${services.length} dịch vụ · $activeCount đang hoạt động',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              for (final service in services) ...[
                _ServiceCard(
                  service: service,
                  onAction: (action) => onAction(service, action),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onAction});

  final ServiceAdminItem service;
  final Future<void> Function(_ServiceAction action) onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: service.isActive ? AppColors.primary.withOpacity(0.14) : AppColors.surfaceElevated,
            child: Icon(
              Icons.content_cut_outlined,
              color: service.isActive ? AppColors.primary : AppColors.textDisabled,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  service.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: service.isActive
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.textDisabled.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  service.isActive ? 'Đang bán' : 'Đã ẩn',
                  style: TextStyle(
                    color: service.isActive ? AppColors.success : AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${Formatters.currency(service.price)} · ${Formatters.duration(service.durationMinutes)}'),
                if ((service.description ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    service.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          isThreeLine: (service.description ?? '').trim().isNotEmpty,
          trailing: PopupMenuButton<_ServiceAction>(
            tooltip: 'Thao tác dịch vụ',
            onSelected: (action) => onAction(action),
            itemBuilder: (context) => [
              const PopupMenuItem<_ServiceAction>(
                value: _ServiceAction.edit,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.edit_outlined),
                  title: Text('Chỉnh sửa'),
                ),
              ),
              PopupMenuItem<_ServiceAction>(
                value: _ServiceAction.toggleActive,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(service.isActive ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  title: Text(service.isActive ? 'Ngừng cung cấp' : 'Kích hoạt lại'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
