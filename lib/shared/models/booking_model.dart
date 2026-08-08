import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/booking_status.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// 1 lich hen cua khach hang - doc/ghi tu bang `bookings` (xem
/// `supabase/schema_bookings.sql`). Dung o cuoi luong Dat lich (tao moi,
/// US-BOOKING-009) va tab "Dat lich" (xem danh sach, US-MYBOOKING-010).
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'service_id') required String serviceId,
    @JsonKey(name: 'staff_id') String? staffId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required BookingStatus status,
    @JsonKey(name: 'total_price') required double totalPrice,
    String? note,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
}

BookingStatus _statusFromJson(String value) => BookingStatus.fromServerValue(value);
String _statusToJson(BookingStatus status) => status.name;