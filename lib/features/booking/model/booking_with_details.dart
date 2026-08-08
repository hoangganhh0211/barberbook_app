import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';

part 'booking_with_details.freezed.dart';
part 'booking_with_details.g.dart';

/// Ket qua tu Supabase embedded select (join) giua `bookings` va
/// `shops`/`services` - dung RIENG cho man danh sach "Dat lich" (tab
/// customerBookings), KHAC voi [BookingModel] (dung khi TAO booking, khong
/// can thong tin join). Tach 2 model rieng vi 2 muc dich khac nhau: 1 ben
/// la "ghi" (insert), 1 ben la "doc kem thong tin hien thi".
@freezed
class BookingWithDetails with _$BookingWithDetails {
  const factory BookingWithDetails({
    required String id,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required BookingStatus status,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'shops') required BookingShopInfo shop,
    @JsonKey(name: 'services') required BookingServiceInfo service,
  }) = _BookingWithDetails;

  factory BookingWithDetails.fromJson(Map<String, dynamic> json) =>
      _$BookingWithDetailsFromJson(json);
}

/// Thong tin Tiem RUT GON, chi lay du field can hien thi o danh sach - dung
/// het `ShopModel` day du se lang phi bang thong (Supabase se tra ve nhieu
/// field khong dung toi).
@freezed
class BookingShopInfo with _$BookingShopInfo {
  const factory BookingShopInfo({
    required String name,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
  }) = _BookingShopInfo;

  factory BookingShopInfo.fromJson(Map<String, dynamic> json) => _$BookingShopInfoFromJson(json);
}

/// Thong tin Dich vu RUT GON, tuong tu [BookingShopInfo].
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