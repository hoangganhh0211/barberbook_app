import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/features/auth/repository/auth_repository.dart';
import 'package:barberbook_app/features/auth/service/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
});