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