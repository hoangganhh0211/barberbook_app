import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/user_role.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

/// Thong tin toi thieu can co ngay sau khi dang nhap de dieu huong dung
/// Shell (Customer/Partner) va kiem soat RBAC co ban.
///
/// Model chi tiet hon (avatar, shop_id dang chon, danh sach permission
/// granular...) se duoc mo rong o Sprint 7 (US-STAFF-002 - RBAC Matrix),
/// khong pha vo cau truc nay.
@freezed
class UserSession with _$UserSession {
  const factory UserSession({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) required UserRole role,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);
}

// Chuyen doi rieng cho UserRole vi day la enum tu dinh nghia (khong phai
// enum "phang" ma json_serializable co the tu suy ra), tai su dung logic
// mapping da co san trong `UserRole.fromServerValue` - KHONG viet lai switch
// rieng o day de tranh 2 noi cung logic bi lech nhau khi BE doi gia tri.
UserRole _roleFromJson(String value) => UserRole.fromServerValue(value);
String _roleToJson(UserRole role) => role.name;
