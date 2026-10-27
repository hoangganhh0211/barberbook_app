import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
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
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return null;

  final result = await ref.watch(staffScheduleRepositoryProvider).fetchMyStaffId();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

final staffBookingRealtimeProvider = StreamProvider<int>((ref) {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  final String? staffId = ref.watch(myStaffIdProvider).valueOrNull;
  if (userId == null || staffId == null) return const Stream<int>.empty();

  final client = ref.watch(supabaseClientProvider);
  final controller = StreamController<int>();
  var eventSequence = 0;
  final channel = client
      .channel('staff-bookings-$userId-$staffId')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'bookings',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'staff_id',
          value: staffId,
        ),
        callback: (_) {
          if (!controller.isClosed) controller.add(++eventSequence);
        },
      )
      .subscribe();

  ref.onDispose(() {
    unawaited(client.removeChannel(channel).then<void>((_) {}));
    unawaited(controller.close());
  });

  return controller.stream;
});

final myStaffInfoProvider = FutureProvider<({String id, String shopId})?>((ref) async {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return null;

  final result = await ref.watch(staffScheduleRepositoryProvider).fetchMyStaffInfo();
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
    final String? userId = ref.watch(authenticatedUserIdProvider);
    if (userId == null) return const <BookingWithDetails>[];

    ref.watch(staffBookingRealtimeProvider);

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
