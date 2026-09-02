import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/model/booking_with_details.dart';
import 'package:barberbook_app/features/staff_schedule/repository/staff_schedule_repository.dart';
import 'package:barberbook_app/features/staff_schedule/service/staff_schedule_service.dart';

final staffScheduleServiceProvider = Provider<StaffScheduleService>((ref) {
  return StaffScheduleService(ref.watch(supabaseClientProvider));
});

final staffScheduleRepositoryProvider = Provider<StaffScheduleRepository>((ref) {
  return StaffScheduleRepositoryImpl(ref.watch(staffScheduleServiceProvider));
});

final myStaffIdProvider = FutureProvider<String?>((ref) async {
  final result = await ref.watch(staffScheduleRepositoryProvider).fetchMyStaffId();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

class ScheduleRange {
  const ScheduleRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) =>
      other is ScheduleRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

final myScheduleProvider = FutureProvider.family<List<BookingWithDetails>, ScheduleRange>(
  (ref, range) async {
    final result = await ref.watch(staffScheduleRepositoryProvider).fetchMySchedule(
          rangeStart: range.start,
          rangeEnd: range.end,
        );
    switch (result) {
      case Success(:final data):
        return data;
      case ResultFailure(:final failure):
        throw failure;
    }
  },
);