import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/notification_type.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 1 thong bao trong app - doc tu bang `notifications` (xem
/// `supabase/schema_notifications.sql`). CHI duoc TAO qua trigger DB
/// (khi booking thay doi), KHONG co API tao thu cong tu Flutter.
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson) required NotificationType type,
    @JsonKey(name: 'related_booking_id') String? relatedBookingId,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

NotificationType _typeFromJson(String value) => NotificationType.fromServerValue(value);
String _typeToJson(NotificationType type) => type.name;