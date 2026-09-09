import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';
import 'package:barberbook_app/features/leave_request/provider/leave_request_provider.dart';
import 'package:barberbook_app/features/leave_request/widget/create_leave_request_sheet.dart';
import 'package:barberbook_app/features/leave_request/widget/leave_request_list_item.dart';
import 'package:barberbook_app/features/staff_schedule/provider/staff_schedule_provider.dart';

class LeaveRequestScreen extends ConsumerWidget {
  const LeaveRequestScreen({super.key});

  Future<void> _handleCreatePressed(BuildContext context, WidgetRef ref) async {
    final ({String id, String shopId})? staffInfo =
        await ref.read(myStaffInfoProvider.future);

    if (!context.mounted) return;

    if (staffInfo == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Bạn chưa được gán làm Thợ, không thể tạo đơn xin nghỉ.')),
        );
      return;
    }

    await showCreateLeaveRequestSheet(context, shopId: staffInfo.shopId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LeaveRequestModel>> requestsAsync = ref.watch(myLeaveRequestsProvider);

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _handleCreatePressed(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Xin nghỉ'),
      ),
      body: AsyncValueWidget<List<LeaveRequestModel>>(
        value: requestsAsync,
        skeletonItemCount: 3,
        isEmpty: (requests) => requests.isEmpty,
        emptyTitle: 'Chưa có đơn xin nghỉ nào',
        emptyDescription: 'Bấm nút "Xin nghỉ" bên dưới để tạo đơn đầu tiên',
        onRetry: () => ref.invalidate(myLeaveRequestsProvider),
        dataBuilder: (requests) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
          itemCount: requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) => LeaveRequestListItem(request: requests[index]),
        ),
      ),
    );
  }
}