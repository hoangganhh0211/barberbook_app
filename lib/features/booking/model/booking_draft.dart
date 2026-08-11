import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';
class BookingDraft {
  const BookingDraft({
    required this.shopId,
    this.selectedService,
    this.selectedStaff,
    this.selectedDateTime,
  });

  final String shopId;
  final ServiceModel? selectedService;
  final StaffModel? selectedStaff;
  final DateTime? selectedDateTime;

  bool get canContinueToDateTime => selectedService != null;

  bool get canConfirm => selectedService != null && selectedDateTime != null;
}