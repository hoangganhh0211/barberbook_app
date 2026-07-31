import 'package:barberbook_app/core/error/failure.dart';

/// Ket qua tra ve tu moi Repository method: hoac [Success] voi du lieu [T],
/// hoac [ResultFailure] voi [Failure] tuong ung.
///
/// Ly do tu viet thay vi dung `dartz`/`fpdart`:
/// - Chi can dung 1 kieu du lieu 2 nhanh (khong can Functor/Monad day du).
/// - Giam dependency ngoai, giam duong cong hoc cho thanh vien moi trong team.
///
/// Cach dung o Provider:
/// ```dart
/// final result = await repository.login(phone, password);
/// switch (result) {
///   case Success(:final data):
///     state = AsyncData(data);
///   case ResultFailure(:final failure):
///     state = AsyncError(failure, StackTrace.current);
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class ResultFailure<T> extends Result<T> {
  const ResultFailure(this.failure);
  final Failure failure;
}
