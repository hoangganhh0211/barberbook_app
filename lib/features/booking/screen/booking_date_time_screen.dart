import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/formatters.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/features/booking/provider/booking_draft_provider.dart';
import 'package:barberbook_app/routes/route_paths.dart';

/// Man Buoc 3 cua luong Dat lich: chon Ngay + Gio.
///
/// GIOI HAN PHAM VI Sprint 3 (ghi ro de khong nham la bug): khung gio duoc
/// SINH CO DINH theo gio mo cua gia dinh 09:00-19:00, moi 30 phut MOT lan -
/// CHUA kiem tra trung lich voi Tho cu the (can he thong Lich lam viec that
/// su, thuoc Sprint 6). Khi co du lieu that, chi can thay [_generateTimeSlots]
/// bang 1 API tra ve slot con trong, KHONG anh huong phan con lai cua man.
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
    final DateTime now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay;
  }

  List<DateTime> _generateTimeSlots(DateTime day, int durationMinutes) {
    final DateTime dayEnd = DateTime(day.year, day.month, day.day, _closeHour);
    final DateTime now = DateTime.now();

    final List<DateTime> slots = [];
    DateTime cursor = DateTime(day.year, day.month, day.day, _openHour);
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
    final List<DateTime> slots = _generateTimeSlots(_selectedDay, draft.selectedService!.durationMinutes);

    return Scaffold(
      appBar: const BrandedAppBar(variant: BrandedAppBarVariant.titleOnly, showBackButton: true),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 30)),
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
                            Formatters.time(slot),
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