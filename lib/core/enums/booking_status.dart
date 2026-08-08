/// Trang thai cua 1 booking - PHAI khop CHINH XAC voi CHECK constraint
/// trong `supabase/schema_bookings.sql` ('pending','confirmed','completed',
/// 'cancelled') - doi 1 ben PHAI doi ca 2.
enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled;

  static BookingStatus fromServerValue(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        // TODO(booking): gui log/crashlytics khi gap status la (BE/FE contract mismatch)
        return BookingStatus.pending;
    }
  }

  String get label => switch (this) {
        BookingStatus.pending => 'Chờ xác nhận',
        BookingStatus.confirmed => 'Đã xác nhận',
        BookingStatus.completed => 'Hoàn tất',
        BookingStatus.cancelled => 'Đã huỷ',
      };

  bool get canCancel => this == BookingStatus.pending || this == BookingStatus.confirmed;
}