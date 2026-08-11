import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';
@freezed
class StaffModel with _$StaffModel {
  const factory StaffModel({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
    @Default(0) double rating,
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);
}