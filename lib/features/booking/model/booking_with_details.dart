import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';

part 'booking_with_details.freezed.dart';
part 'booking_with_details.g.dart';
@freezed
class BookingWithDetails with _$BookingWithDetails {
  const factory BookingWithDetails({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required BookingStatus status,
    @JsonKey(name: 'total_price') required double totalPrice,
    // Snapshot ten khach hang (trigger DB tu dien, xem
    // schema_booking_customer_name.sql) - dung o man "Lich lam viec cua toi"
    // (Sprint 6) de Staff biet ai sap toi. Co the rong ('') voi booking tao
    // TRUOC khi chay migration nay.
    @JsonKey(name: 'customer_name') @Default('') String customerName,
    @JsonKey(name: 'shops') required BookingShopInfo shop,
    @JsonKey(name: 'services') required BookingServiceInfo service,
  }) = _BookingWithDetails;

  factory BookingWithDetails.fromJson(Map<String, dynamic> json) =>
      _$BookingWithDetailsFromJson(json);
}
@freezed
class BookingShopInfo with _$BookingShopInfo {
  const factory BookingShopInfo({
    required String name,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
  }) = _BookingShopInfo;

  factory BookingShopInfo.fromJson(Map<String, dynamic> json) => _$BookingShopInfoFromJson(json);
}
@freezed
class BookingServiceInfo with _$BookingServiceInfo {
  const factory BookingServiceInfo({
    required String name,
    @JsonKey(name: 'duration_minutes') required int durationMinutes,
  }) = _BookingServiceInfo;

  factory BookingServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$BookingServiceInfoFromJson(json);
}

BookingStatus _statusFromJson(String value) => BookingStatus.fromServerValue(value);
String _statusToJson(BookingStatus status) => status.name;