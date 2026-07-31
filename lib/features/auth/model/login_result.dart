import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:barberbook_app/features/auth/model/auth_tokens.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';

part 'login_result.freezed.dart';
part 'login_result.g.dart';

/// Response day du cua API `/auth/login` va `/auth/social-login` - gom
/// thong tin user + cap token trong 1 lan goi (dung quy uoc REST pho bien,
/// tranh phai goi them API rieng de lay profile ngay sau khi login).
@freezed
class LoginResult with _$LoginResult {
  const factory LoginResult({
    required UserSession user,
    required AuthTokens tokens,
  }) = _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
}
