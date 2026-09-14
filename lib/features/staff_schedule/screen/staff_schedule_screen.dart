import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
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
    _weekStart = _startOfWeek(DateTime.now());
  }

  DateTime _startOfWeek(DateTime date) {
    final DateTime dayOnly = DateTime(date.year, date.month, date.day);
    return dayOnly.subtract(Duration(days: dayOnly.weekday - 1));
  }

  void _goToPreviousWeek() => setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _goToNextWeek() => setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  @override
  Widget build(BuildContext context) {
    final AsyncValue<String?> myStaffIdAsync = ref.watch(myStaffIdProvider);

    final AuthState authState = ref.watch(authControllerProvider);
    final bool isShopAdmin = authState is AuthAuthenticated && authState.session.role.isShopAdmin;

    return Scaffold(
      appBar: BrandedAppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.event_busy_outlined),
            tooltip: 'Xin nghỉ phép',
            onPressed: () => context.push(RoutePaths.partnerLeaveRequests),
          ),
          if (isShopAdmin)
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
    final DateTime weekEnd =
        weekStart.add(const Duration(days: 7)).subtract(const Duration(seconds: 1));
    final ScheduleRange range = ScheduleRange(start: weekStart, end: weekEnd);
    final AsyncValue<List<BookingWithDetails>> scheduleAsync = ref.watch(myScheduleProvider(range));

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
        itemBuilder: (context, index) => StaffScheduleItem(booking: schedule[index]),
      ),
    );
  }
}