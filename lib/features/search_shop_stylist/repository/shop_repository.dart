import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/search_shop_stylist/service/shop_service.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Interface truu tuong - Provider PHAI phu thuoc vao day, KHONG phu thuoc
/// truc tiep [ShopRepositoryImpl] (Dependency Inversion), de de test.
abstract class ShopRepository {
  Future<Result<List<ShopModel>>> fetchShops({String? searchQuery});

  Future<Result<ShopModel>> fetchShopById(String shopId);
}

class ShopRepositoryImpl implements ShopRepository {
  ShopRepositoryImpl(this._shopService);

  final ShopService _shopService;

  @override
  Future<Result<List<ShopModel>>> fetchShops({String? searchQuery}) async {
    try {
      final List<ShopModel> shops = await _shopService.fetchShops(searchQuery: searchQuery);
      return Success(shops);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Result<ShopModel>> fetchShopById(String shopId) async {
    try {
      final ShopModel shop = await _shopService.fetchShopById(shopId);
      return Success(shop);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }
}
