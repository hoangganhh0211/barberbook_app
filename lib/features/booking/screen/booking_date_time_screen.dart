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
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/routes/route_paths.dart';
class BookingDateTimeScreen extends ConsumerStatefulWidget {
  const BookingDateTimeScreen({super.key});

  @override
  ConsumerState<BookingDateTimeScreen> createState() => _BookingDateTimeScreenState();
}

class _BookingDateTimeScreenState extends ConsumerState<BookingDateTimeScreen> {
  static const int _openHour = 9;
  static const int _closeHour = 19;
  static const int _slotStepMinutes = 30;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  DateTime? _selectedSlot;

  @override
  void initState() {
    super.initState();
    _selectedDay = VietnamTime.todayCalendarDate();
    _focusedDay = _selectedDay;
  }

  List<DateTime> _generateTimeSlots(DateTime day, int durationMinutes) {
    // Store real instants in UTC, derived from the shop's Vietnam wall clock.
    final DateTime dayEnd = VietnamTime.wallToUtc(
      DateTime(day.year, day.month, day.day, _closeHour),
    );
    final DateTime now = VietnamTime.nowUtc();

    final List<DateTime> slots = [];
    DateTime cursor = VietnamTime.wallToUtc(
      DateTime(day.year, day.month, day.day, _openHour),
    );
    while (!cursor.add(Duration(minutes: durationMinutes)).isAfter(dayEnd)) {
      if (cursor.isAfter(now)) {
        slots.add(cursor);
      }
      cursor = cursor.add(const Duration(minutes: _slotStepMinutes));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final BookingDraft? draft = ref.watch(bookingDraftControllerProvider);

    if (draft == null || draft.selectedService == null) {
      return Scaffold(
        appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
        body: const Center(child: Text('Vui lòng chọn dịch vụ trước.')),
      );
    }

    final BookingDraftController controller = ref.read(bookingDraftControllerProvider.notifier);
    final DateTime today = VietnamTime.todayCalendarDate();
    final List<DateTime> slots = _generateTimeSlots(_selectedDay, draft.selectedService!.durationMinutes);

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
                _selectedSlot = null; // doi ngay -> reset gio da chon
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
              child: Text('Chọn giờ', style: AppTextStyles.titleMedium),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: slots.isEmpty
                ? const EmptyStateWidget(
                    title: 'Không còn khung giờ trống',
                    description: 'Vui lòng chọn ngày khác',
                  )
                : GridView.builder(
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
                      final bool isSelected = _selectedSlot == slot;
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
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppPrimaryButton(
              label: 'Tiếp tục',
              onPressed: _selectedSlot != null
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