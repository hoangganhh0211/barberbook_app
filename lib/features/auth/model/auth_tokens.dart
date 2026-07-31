import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// Cap token tra ve tu API `/auth/login` va `/auth/refresh-token`.
///
/// `@JsonKey(name: ...)` map dung quy uoc snake_case cua BE (`access_token`,
/// `refresh_token`) sang camelCase cua Dart - KHONG doi ten field Dart de
/// khop BE, giu code Dart dung convention.
@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) => _$AuthTokensFromJson(json);
}
