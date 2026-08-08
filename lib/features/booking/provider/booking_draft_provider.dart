import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/features/booking/model/booking_draft.dart';
import 'package:barberbook_app/shared/models/service_model.dart';
import 'package:barberbook_app/shared/models/staff_model.dart';

/// Quan ly [BookingDraft] xuyen suot luong dat lich nhieu man. `state` la
/// `null` khi CHUA co lan dat lich nao dang thuc hien (vd: nguoi dung chua
/// bam "Dat lich ngay" tu man nao ca).
class BookingDraftController extends Notifier<BookingDraft?> {
  @override
  BookingDraft? build() => null;

  /// Goi tu [ShopDetailScreen] khi bam "Dat lich ngay" - khoi tao 1 lan dat
  /// lich moi, XOA moi lua chon cu (neu nguoi dung tung bat dau dat lich o
  /// tiem khac roi thoat giua chung ma khong hoan tat).
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

  /// Truyen `null` de chon "Bat ky tho nao" - xem giai thich trong
  /// [BookingDraft] ve ly do KHONG dung `copyWith` cho truong hop nay.
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

  /// Goi sau khi tao booking thanh cong (Chuc nang 3), hoac khi nguoi dung
  /// huy giua chung - tranh de sot du lieu cu anh huong lan dat lich sau.
  void reset() => state = null;
}

final bookingDraftControllerProvider = NotifierProvider<BookingDraftController, BookingDraft?>(
  BookingDraftController.new,
);