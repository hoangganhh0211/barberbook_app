import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/enums/app_permission.dart';
import 'package:barberbook_app/core/enums/booking_status.dart';
import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/rbac/rbac_matrix.dart';
import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/vietnam_time.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/leave_request/screen/leave_approval_screen.dart';
import 'package:barberbook_app/features/staff_schedule/provider/staff_schedule_provider.dart';
import 'package:barberbook_app/features/staff_schedule/widget/staff_schedule_item.dart';
import 'package:barberbook_app/features/staff_schedule/widget/week_selector.dart';
import 'package:barberbook_app/routes/route_paths.dart';

class StaffScheduleScreen extends ConsumerStatefulWidget {
  const StaffScheduleScreen({super.key});

  @override
  ConsumerState<StaffScheduleScreen> createState() => _StaffScheduleScreenState();
}

class _StaffScheduleScreenState extends ConsumerState<StaffScheduleScreen> {
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    _weekStart = _startOfWeek(VietnamTime.todayCalendarDate());
  }

  DateTime _startOfWeek(DateTime date) {
    final DateTime dayOnly = DateTime(date.year, date.month, date.day);
    return DateTime(dayOnly.year, dayOnly.month, dayOnly.day - (dayOnly.weekday - 1));
  }

  void _goToPreviousWeek() => setState(() {
        _weekStart = VietnamTime.calendarDateAfter(_weekStart, -7);
      });

  void _goToNextWeek() => setState(() {
        _weekStart = VietnamTime.calendarDateAfter(_weekStart, 7);
      });

  @override
  Widget build(BuildContext context) {
    final AuthState authState = ref.watch(authControllerProvider);
    final UserRole? role = authState is AuthAuthenticated ? authState.session.role : null;

    // For owners, the "Lịch làm việc" tab is used only to review leave requests.
    // Do not load staff-specific schedule providers for an owner account.
    if (role == UserRole.owner) {
      return const LeaveApprovalScreen(showBackButton: false);
    }

    final AsyncValue<String?> myStaffIdAsync = ref.watch(myStaffIdProvider);
    final bool canRequestLeave =
        role != null && RbacMatrix.allows(role, AppPermission.leaveRequest);
    final bool canApproveLeave =
        role != null && RbacMatrix.allows(role, AppPermission.leaveApprove);

    return Scaffold(
      appBar: BrandedAppBar(
        actions: [
          if (canRequestLeave)
            IconButton(
              icon: const Icon(Icons.event_busy_outlined),
              tooltip: 'Xin nghỉ phép',
              onPressed: () => context.push(RoutePaths.partnerLeaveRequests),
            ),
          if (canApproveLeave)
            IconButton(
              icon: const Icon(Icons.fact_check_outlined),
              tooltip: 'Duyệt đơn nghỉ',
              onPressed: () => context.push(RoutePaths.partnerLeaveApproval),
            ),
        ],
      ),
      body: myStaffIdAsync.when(
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
        data: (staffId) {
          if (staffId == null) {
            return const EmptyStateWidget(
              icon: Icons.badge_outlined,
              title: 'Chưa được gán làm Thợ',
              description:
                  'Liên hệ chủ tiệm để được gán vào danh sách Thợ trước khi xem lịch làm việc.',
            );
          }

          return Column(
            children: [
              WeekSelector(
                weekStart: _weekStart,
                onPrevious: _goToPreviousWeek,
                onNext: _goToNextWeek,
              ),
              Expanded(child: _ScheduleList(weekStart: _weekStart)),
            ],
          );
        },
      ),
    );
  }
}

class _ScheduleList extends ConsumerWidget {
  const _ScheduleList({required this.weekStart});

  final DateTime weekStart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // End is exclusive: next Monday 00:00 Vietnam time.
    final DateTime weekEnd = VietnamTime.calendarDateAfter(weekStart, 7);
    final ScheduleRange range = ScheduleRange(start: weekStart, end: weekEnd);
    final AsyncValue<List<BookingWithDetails>> scheduleAsync = ref.watch(myScheduleProvider(range));

    Future<void> handleCompleteBooking(BookingWithDetails booking) async {
      final bool? shouldComplete = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Xác nhận hoàn thành dịch vụ'),
          content: Text(
            'Bạn xác nhận đã thực hiện xong dịch vụ ${booking.service.name} cho '
            '${booking.customerName.isEmpty ? 'khách hàng' : booking.customerName}? '
            'Khách hàng sẽ được thông báo và có thể đánh giá dịch vụ.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Chưa hoàn thành'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.task_alt_rounded),
              label: const Text('Xác nhận hoàn thành'),
            ),
          ],
        ),
      );
      if (shouldComplete != true || !context.mounted) return;

      final failure = await ref.read(staffScheduleRepositoryProvider).completeBooking(booking.id);
      if (!context.mounted) return;

      if (failure != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
          );
        return;
      }

      ref.invalidate(myScheduleProvider(range));
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Đã xác nhận hoàn thành dịch vụ.'),
            backgroundColor: AppColors.success,
          ),
        );
    }

    return AsyncValueWidget<List<BookingWithDetails>>(
      value: scheduleAsync,
      skeletonItemCount: 3,
      isEmpty: (schedule) => schedule.isEmpty,
      emptyTitle: 'Không có lịch hẹn nào trong tuần này',
      onRetry: () => ref.invalidate(myScheduleProvider(range)),
      dataBuilder: (schedule) => ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: schedule.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final booking = schedule[index];
          return StaffScheduleItem(
            booking: booking,
            onComplete: booking.status == BookingStatus.confirmed
                ? handleCompleteBooking
                : null,
          );
        },
      ),
    );
  }
}