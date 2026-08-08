import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

/// Trang thai TAM THOI cua 1 lan dat lich dang thuc hien - KHONG luu
/// Database, chi ton tai trong bo nho (qua [BookingDraftController]) khi
/// nguoi dung di qua nhieu man (Dich vu+Tho -> Ngay gio -> Xac nhan). Bi
/// xoa/reset khi hoan tat hoac thoat giua chung (xem `reset()`).
///
/// KHONG dung `freezed`/`copyWith` o day - vi [selectedStaff] can duoc set
/// ve `null` co chu y (nghia la "Bat ky tho nao"), trong khi quy uoc
/// `copyWith` thong thuong coi `null` la "khong doi gia tri". De tranh nham
/// lan, moi thay doi deu di qua method rieng cua Controller
/// (`selectStaff(null)` roi rang la chon "Bat ky", khong phai "khong doi").
class BookingDraft {
  const BookingDraft({
    required this.shopId,
    this.selectedService,
    this.selectedStaff,
    this.selectedDateTime,
  });

  final String shopId;
  final ServiceModel? selectedService;

  /// `null` = "Bat ky tho nao" (khach khong chi dinh tho cu the).
  final StaffModel? selectedStaff;
  final DateTime? selectedDateTime;

  bool get canContinueToDateTime => selectedService != null;

  bool get canConfirm => selectedService != null && selectedDateTime != null;
}