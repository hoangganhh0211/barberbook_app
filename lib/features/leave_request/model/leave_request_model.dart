import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/leave_request_status.dart';

part 'leave_request_model.freezed.dart';
part 'leave_request_model.g.dart';

@freezed
class LeaveRequestModel with _$LeaveRequestModel {
  const factory LeaveRequestModel({
    required String id,
    @JsonKey(name: 'staff_profile_id') required String staffProfileId,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'staff_name') required String staffName,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    String? reason,
    @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) required LeaveRequestStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LeaveRequestModel;

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestModelFromJson(json);
}

LeaveRequestStatus _statusFromJson(String value) => LeaveRequestStatus.fromServerValue(value);
String _statusToJson(LeaveRequestStatus status) => status.name;