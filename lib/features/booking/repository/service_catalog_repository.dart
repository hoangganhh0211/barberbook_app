import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/booking/service/service_catalog_service.dart';
import 'package:barberbook_app/shared/models/service_model.dart';

abstract class ServiceCatalogRepository {
  Future<Result<List<ServiceModel>>> fetchServicesByShop(String shopId);
}

class ServiceCatalogRepositoryImpl implements ServiceCatalogRepository {
  ServiceCatalogRepositoryImpl(this._service);

  final ServiceCatalogService _service;

  @override
  Future<Result<List<ServiceModel>>> fetchServicesByShop(String shopId) async {
    try {
      final List<ServiceModel> services = await _service.fetchServicesByShop(shopId);
      return Success(services);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }
}