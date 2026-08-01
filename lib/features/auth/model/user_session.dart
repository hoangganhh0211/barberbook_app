import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/user_role.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';

/// Thong tin toi thieu can co ngay sau khi dang nhap de dieu huong dung
/// Shell (Customer/Partner) va kiem soat RBAC co ban.
///
/// Nguon du lieu: bang `profiles` trong Supabase Postgres (xem
/// `supabase/schema.sql`) - Supabase Auth mac dinh KHONG co san field
/// `role`/`full_name`, nen phai luu rieng trong 1 bang co lien ket toi
/// `auth.users.id`.
@freezed
class UserSession with _$UserSession {
  const UserSession._();

  const factory UserSession({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) required UserRole role,
  }) = _UserSession;

  factory UserSession.fromJson(Map<String, dynamic> json) => _$UserSessionFromJson(json);

  /// Dung rieng khi doc truc tiep tu bang `profiles` cua Supabase - ten cot
  /// khac voi `fromJson` chuan (`id` thay vi `user_id`, vi `id` la quy uoc
  /// Postgres/Supabase cho khoa chinh, dong bo voi `auth.users.id`).
  factory UserSession.fromProfileRow(Map<String, dynamic> row) {
    return UserSession(
      userId: row['id'] as String,
      fullName: (row['full_name'] as String?) ?? '',
      role: UserRole.fromServerValue((row['role'] as String?) ?? 'customer'),
    );
  }
}

// Chuyen doi rieng cho UserRole vi day la enum tu dinh nghia (khong phai
// enum "phang" ma json_serializable co the tu suy ra), tai su dung logic
// mapping da co san trong `UserRole.fromServerValue` - KHONG viet lai switch
// rieng o day de tranh 2 noi cung logic bi lech nhau khi doi gia tri.
UserRole _roleFromJson(String value) => UserRole.fromServerValue(value);
String _roleToJson(UserRole role) => role.name;