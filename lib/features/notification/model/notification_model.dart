import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/notification_type.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';
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