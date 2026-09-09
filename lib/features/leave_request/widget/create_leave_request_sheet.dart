import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/leave_request/provider/leave_request_provider.dart';


Future<bool?> showCreateLeaveRequestSheet(BuildContext context, {required String shopId}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _CreateLeaveRequestSheetContent(shopId: shopId),
  );
}

class _CreateLeaveRequestSheetContent extends ConsumerStatefulWidget {
  const _CreateLeaveRequestSheetContent({required this.shopId});

  final String shopId;

  @override
  ConsumerState<_CreateLeaveRequestSheetContent> createState() =>
      _CreateLeaveRequestSheetContentState();
}

class _CreateLeaveRequestSheetContentState
    extends ConsumerState<_CreateLeaveRequestSheetContent> {
  final _reasonController = TextEditingController();
  DateTimeRange? _selectedRange;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: today,
      lastDate: today.add(const Duration(days: 90)),
      initialDateRange: _selectedRange,
    );

    if (range != null) setState(() => _selectedRange = range);
  }

  Future<void> _handleSubmit() async {
    if (_selectedRange == null) return;

    setState(() => _isSubmitting = true);

    final result = await ref.read(leaveRequestRepositoryProvider).createLeaveRequest(
          shopId: widget.shopId,
          startDate: _selectedRange!.start,
          endDate: _selectedRange!.end,
          reason: _reasonController.text.trim().isEmpty ? null : _reasonController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (result) {
      case Success():
        ref.invalidate(myLeaveRequestsProvider);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Tạo đơn xin nghỉ', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _pickDateRange,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(
              _selectedRange == null
                  ? 'Chọn khoảng ngày nghỉ'
                  : '${Formatters.date(_selectedRange!.start)} - ${Formatters.date(_selectedRange!.end)}',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Lý do xin nghỉ (không bắt buộc)...',
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Gửi đơn',
            isLoading: _isSubmitting,
            onPressed: _selectedRange != null ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }
}