import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/enums/leave_request_status.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/leave_request/model/leave_request_model.dart';
import 'package:barberbook_app/features/leave_request/provider/leave_request_provider.dart';
import 'package:barberbook_app/features/leave_request/widget/leave_request_list_item.dart';


class LeaveApprovalScreen extends ConsumerWidget {
  const LeaveApprovalScreen({super.key});

  Future<void> _handleReview(
    BuildContext context,
    WidgetRef ref,
    LeaveRequestModel request, {
    required bool approve,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(approve ? 'Duyệt đơn nghỉ' : 'Từ chối đơn nghỉ'),
        content: Text(
          '${request.staffName.isEmpty ? "Nhân viên" : request.staffName}: '
          '${Formatters.date(request.startDate)} - ${Formatters.date(request.endDate)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              approve ? 'Duyệt' : 'Từ chối',
              style: TextStyle(color: approve ? AppColors.success : AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final failure = await ref.read(leaveRequestRepositoryProvider).reviewLeaveRequest(
          requestId: request.id,
          approve: approve,
        );

    if (!context.mounted) return;

    if (failure == null) {
      ref.invalidate(allLeaveRequestsProvider);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(approve ? 'Đã duyệt đơn nghỉ' : 'Đã từ chối đơn nghỉ')));
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(failure.message), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LeaveRequestModel>> requestsAsync = ref.watch(allLeaveRequestsProvider);

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: AsyncValueWidget<List<LeaveRequestModel>>(
        value: requestsAsync,
        skeletonItemCount: 4,
        isEmpty: (requests) => requests.isEmpty,
        emptyTitle: 'Chưa có đơn xin nghỉ nào',
        onRetry: () => ref.invalidate(allLeaveRequestsProvider),
        dataBuilder: (requests) {
          final List<LeaveRequestModel> pending =
              requests.where((r) => r.status == LeaveRequestStatus.pending).toList();
          final List<LeaveRequestModel> reviewed =
              requests.where((r) => r.status != LeaveRequestStatus.pending).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (pending.isNotEmpty) ...[
                Text('Chờ duyệt (${pending.length})', style: AppTextStyles.titleMedium),
                const SizedBox(height: 10),
                for (final request in pending) ...[
                  LeaveRequestListItem(
                    request: request,
                    showStaffName: true,
                    trailing: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _handleReview(context, ref, request, approve: false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                            child: const Text('Từ chối'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _handleReview(context, ref, request, approve: true),
                            child: const Text('Duyệt'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 20),
              ],
              if (reviewed.isNotEmpty) ...[
                Text('Đã xử lý', style: AppTextStyles.titleMedium),
                const SizedBox(height: 10),
                for (final request in reviewed) ...[
                  LeaveRequestListItem(request: request, showStaffName: true),
                  const SizedBox(height: 10),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}