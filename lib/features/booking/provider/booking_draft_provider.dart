import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';
class BookingDraftController extends Notifier<BookingDraft?> {
  @override
  BookingDraft? build() => null;
  void start(String shopId) {
    state = BookingDraft(shopId: shopId);
  }

  void selectService(ServiceModel service) {
    final BookingDraft? current = state;
    if (current == null) return;
    state = BookingDraft(
      shopId: current.shopId,
      selectedService: service,
      selectedStaff: current.selectedStaff,
      selectedDateTime: current.selectedDateTime,
    );
  }
  void selectStaff(StaffModel? staff) {
    final BookingDraft? current = state;
    if (current == null) return;
    state = BookingDraft(
      shopId: current.shopId,
      selectedService: current.selectedService,
      selectedStaff: staff,
      selectedDateTime: current.selectedDateTime,
    );
  }

  void selectDateTime(DateTime dateTime) {
    final BookingDraft? current = state;
    if (current == null) return;
    state = BookingDraft(
      shopId: current.shopId,
      selectedService: current.selectedService,
      selectedStaff: current.selectedStaff,
      selectedDateTime: dateTime,
    );
  }
  void reset() => state = null;
}

final bookingDraftControllerProvider = NotifierProvider<BookingDraftController, BookingDraft?>(
  BookingDraftController.new,
);