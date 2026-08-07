import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

/// 1 "Tho" hien thi cho khach chon o Buoc 2 luong Dat lich (US-BOOKING-009).
///
/// LUU Y: CHUA lien ket voi tai khoan dang nhap that (xem doc comment trong
/// `supabase/schema_services_staff.sql`) - model nay se duoc mo rong (them
/// `profileId`...) khi Sprint 6/7 hoan thien he thong Nhan su that su.
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