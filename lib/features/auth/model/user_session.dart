import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/core/enums/user_role.dart';

part 'user_session.freezed.dart';
part 'user_session.g.dart';


@freezed
class UserSession with _$UserSession {
  const UserSession._();

  const factory UserSession({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
    String? phone,
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
      phone: row['phone'] as String?,
      role: UserRole.fromServerValue((row['role'] as String?) ?? 'customer'),
    );
  }
}


UserRole _roleFromJson(String value) => UserRole.fromServerValue(value);
String _roleToJson(UserRole role) => role.name;