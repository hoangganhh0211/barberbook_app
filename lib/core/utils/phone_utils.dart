String normalizePhone(String phone) {
  String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.startsWith('+84')) {
    digits = '84${digits.substring(3)}';
  } else if (digits.startsWith('0')) {
    digits = '84${digits.substring(1)}';
  }
  return digits;
}