import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/features/auth/repository/auth_repository.dart';
import 'package:barberbook_app/features/auth/service/auth_api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.watch(dioClientProvider).dio;
  return AuthApiService(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    apiService: ref.watch(authApiServiceProvider),
    secureStorage: ref.watch(secureStorageServiceProvider),
  );
});
