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