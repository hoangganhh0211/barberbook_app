/// Loai thong bao - PHAI khop CHINH XAC voi CHECK constraint trong
/// `supabase/schema_notifications.sql` ('general','booking','promotion').
enum NotificationType {
  general,
  booking,
  promotion;

  static NotificationType fromServerValue(String value) {
    switch (value.toLowerCase()) {
      case 'booking':
        return NotificationType.booking;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.general;
    }
  }
}