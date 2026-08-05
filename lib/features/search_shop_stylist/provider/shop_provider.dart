import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/providers/core_providers.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/search_shop_stylist/repository/shop_repository.dart';
import 'package:barberbook_app/features/search_shop_stylist/service/shop_service.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

final shopServiceProvider = Provider<ShopService>((ref) {
  return ShopService(ref.watch(supabaseClientProvider));
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepositoryImpl(ref.watch(shopServiceProvider));
});

/// Danh sach Tiem, loc theo [searchQuery] (truyen chuoi rong `''` de lay
/// TOAN BO tiem - dung cho tab Home/Tiem khi chua go tim kiem gi).
///
/// Dung `family` de moi gia tri query khac nhau duoc Riverpod cache RIENG -
/// go tim kiem xong xoa di se tu dong quay lai ket qua cua query truoc do
/// (da cache) thay vi phai goi lai API. [Failure] duoc `throw` de
/// `AsyncValue.error` bat duoc dung kieu du lieu, khop voi cach
/// `AsyncValueWidget` (core/widgets) doc loi.
final shopListProvider = FutureProvider.family<List<ShopModel>, String>((ref, searchQuery) async {
  final result = await ref.watch(shopRepositoryProvider).fetchShops(searchQuery: searchQuery);
  switch (result) {
    case Success(:final data):
      return data;
    case ResultFailure(:final failure):
      throw failure;
  }
});
