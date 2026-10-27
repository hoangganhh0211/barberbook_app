import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/auth/provider/auth_controller.dart';
import 'package:barberbook_app/features/search_shop_stylist/repository/shop_repository.dart';
import 'package:barberbook_app/features/search_shop_stylist/service/shop_service.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(ref.watch(supabaseClientProvider));
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl(ref.watch(shopServiceProvider));
});
final shopListProvider = FutureProvider.family<List<ShopModel>, String>((ref, searchQuery) async {
  final result = await ref.watch(shopRepositoryProvider).fetchShops(searchQuery: searchQuery);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
final shopDetailProvider = FutureProvider.family<ShopModel, String>((ref, shopId) async {
  final result = await ref.watch(shopRepositoryProvider).fetchShopById(shopId);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});

final myOwnedShopProvider = FutureProvider<ShopModel?>((ref) async {
  final String? userId = ref.watch(authenticatedUserIdProvider);
  if (userId == null) return null;

  final result = await ref.watch(shopRepositoryProvider).fetchMyOwnedShop();
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
