enum LeaveRequestStatus {
  pending,
  approved,
  rejected;

  static LeaveRequestStatus fromServerValue(String value) {
    switch (value.toLowerCase()) {
      case 'approved':
        return LeaveRequestStatus.approved;
      case 'rejected':
        return LeaveRequestStatus.rejected;
      default:
        return LeaveRequestStatus.pending;
    }
  }

  String get label => switch (this) {
        LeaveRequestStatus.pending => 'Chờ duyệt',
        LeaveRequestStatus.approved => 'Đã duyệt',
        LeaveRequestStatus.rejected => 'Từ chối',
      };
}