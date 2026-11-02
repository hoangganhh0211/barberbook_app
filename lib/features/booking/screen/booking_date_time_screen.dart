import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/utils/vietnam_time.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/features/booking/provider/booking_catalog_providers.dart';
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/routes/route_paths.dart';

class BookingDateTimeScreen extends ConsumerStatefulWidget {
  const BookingDateTimeScreen({super.key});

  @override
  ConsumerState<BookingDateTimeScreen> createState() => _BookingDateTimeScreenState();
}

class _BookingDateTimeScreenState extends ConsumerState<BookingDateTimeScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  DateTime? _selectedSlot;

  @override
  void initState() {
    super.initState();
    _selectedDay = VietnamTime.todayCalendarDate();
    _focusedDay = _selectedDay;
  }

  @override
  Widget build(BuildContext context) {
    final BookingDraft? draft = ref.watch(bookingDraftControllerProvider);

    if (draft == null || draft.selectedService == null || draft.selectedStaff == null) {
      return Scaffold(
        appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
        body: const Center(child: Text('Vui lòng chọn dịch vụ và thợ trước.')),
      );
    }

    final query = StaffAvailabilityQuery(
      shopId: draft.shopId,
      staffId: draft.selectedStaff!.id,
      serviceId: draft.selectedService!.id,
      date: _selectedDay,
    );
    final slotsAsync = ref.watch(availableStaffSlotsProvider(query));
    final BookingDraftController controller = ref.read(bookingDraftControllerProvider.notifier);
    final DateTime today = VietnamTime.todayCalendarDate();
    final List<DateTime> availableSlots = slotsAsync.valueOrNull ?? const <DateTime>[];
    final bool canContinueWithSelectedSlot = _selectedSlot != null &&
        availableSlots.any((slot) => slot.isAtSameMomentAs(_selectedSlot!));

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: Column(
        children: [
          TableCalendar(
            firstDay: today,
            lastDay: VietnamTime.calendarDateAfter(today, 30),
            focusedDay: _focusedDay,
            locale: 'vi_VN',
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: const {CalendarFormat.week: 'Tuần'},
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedSlot = null;
              });
            },
            onPageChanged: (focusedDay) => _focusedDay = focusedDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppTextStyles.titleMedium,
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: AppTextStyles.caption,
              weekendStyle: AppTextStyles.caption,
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: AppTextStyles.bodyRegular,
              weekendTextStyle: AppTextStyles.bodyRegular,
              outsideTextStyle: TextStyle(color: AppColors.textDisabled),
              todayDecoration: BoxDecoration(color: AppColors.border, shape: BoxShape.circle),
              todayTextStyle: AppTextStyles.bodyRegular,
              selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedTextStyle: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giờ còn trống của ${draft.selectedStaff!.fullName}',
                style: AppTextStyles.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: slotsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Không thể tải lịch trống của thợ.'),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref.invalidate(availableStaffSlotsProvider(query)),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (slots) {
                if (slots.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'Thợ không còn khung giờ trống',
                    description: 'Thợ đã có lịch hẹn hoặc nghỉ trong ngày này. Vui lòng chọn ngày khác.',
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final DateTime slot = slots[index];
                    final bool isSelected = _selectedSlot?.isAtSameMomentAs(slot) ?? false;
                    return InkWell(
                      onTap: () => setState(() => _selectedSlot = slot),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Text(
                          Formatters.timeVietnam(slot),
                          style: AppTextStyles.bodyRegular.copyWith(
                            color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppPrimaryButton(
              label: 'Tiếp tục',
              onPressed: canContinueWithSelectedSlot
                  ? () {
                      controller.selectDateTime(_selectedSlot!);
                      context.push(RoutePaths.bookingConfirm);
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
