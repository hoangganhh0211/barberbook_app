import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'package:barberbook_app/core/enums/user_role.dart';
import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/model/user_session.dart';
import 'package:barberbook_app/features/auth/provider/auth_providers.dart';


sealed class AuthState {
  const AuthState();
}


final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);
  final UserSession session;
}
class AuthController extends Notifier<AuthState> {
  StreamSubscription<supa.AuthState>? _authSubscription;

  @override
  AuthState build() {
    final Stream<supa.AuthState> authStream = ref.read(authServiceProvider).onAuthStateChange;
    _authSubscription = authStream.listen(_handleAuthStateChange);
    ref.onDispose(() => _authSubscription?.cancel());

    return const AuthUnknown();
  }

  Future<void> _handleAuthStateChange(supa.AuthState data) async {
    final supa.Session? session = data.session;
    if (session == null) {
      state = const AuthUnauthenticated();
      return;
    }

    final Result<UserSession> result = await ref.read(authRepositoryProvider).fetchUserSession(
          session.user.id,
        );

    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data);
      case ResultFailure():
        await ref.read(authRepositoryProvider).logout();
        state = const AuthUnauthenticated();
    }
  }
  Future<Failure?> loginWithPhonePassword({
    required String phone,
    required String password,
  }) {
    return ref.read(authRepositoryProvider).login(phone: phone, password: password);
  }
  Future<Failure?> register({
    required String phone,
    required String fullName,
    required String password,
  }) {
    return ref.read(authRepositoryProvider).register(
          phone: phone,
          fullName: fullName,
          password: password,
        );
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).logout();
  }
  Future<void> refreshSession() async {
    final AuthState current = state;
    if (current is! AuthAuthenticated) return;

    final Result<UserSession> result =
        await ref.read(authRepositoryProvider).fetchUserSession(current.session.userId);

    switch (result) {
      case Success(:final data):
        state = AuthAuthenticated(data);
      case ResultFailure():
        break;
    }
  }
  void debugSignInAs(UserRole role) {
    state = AuthAuthenticated(
      UserSession(userId: 'debug-user-id', fullName: 'Người dùng Demo', role: role),
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);