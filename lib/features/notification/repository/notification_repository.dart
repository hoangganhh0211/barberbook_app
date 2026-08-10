import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/error/supabase_error_mapper.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/features/notification/model/notification_model.dart';
import 'package:barberbook_app/features/notification/service/notification_service.dart';

abstract class NotificationRepository {
  Future<Result<List<NotificationModel>>> fetchMyNotifications();

  Future<Failure?> markAsRead(String notificationId);

  Future<Failure?> markAllAsRead();
}

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._service);

  final NotificationService _service;

  @override
  Future<Result<List<NotificationModel>>> fetchMyNotifications() async {
    try {
      final List<NotificationModel> notifications = await _service.fetchMyNotifications();
      return Success(notifications);
    } on PostgrestException catch (e) {
      return ResultFailure(mapSupabasePostgrestError(e));
    } on StateError catch (e) {
      return ResultFailure(AuthFailure(e.message));
    } catch (_) {
      return const ResultFailure(NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.'));
    }
  }

  @override
  Future<Failure?> markAsRead(String notificationId) async {
    try {
      await _service.markAsRead(notificationId);
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }

  @override
  Future<Failure?> markAllAsRead() async {
    try {
      await _service.markAllAsRead();
      return null;
    } on PostgrestException catch (e) {
      return mapSupabasePostgrestError(e);
    } catch (_) {
      return const NetworkFailure('Không có kết nối mạng. Vui lòng kiểm tra Internet.');
    }
  }
}