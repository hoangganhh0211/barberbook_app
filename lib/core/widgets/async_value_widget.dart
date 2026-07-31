import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/core/widgets/error_state_widget.dart';
import 'package:barberbook_app/core/widgets/skeleton_loading.dart';

/// Widget dieu phoi CHUNG cho 4 trang thai: Loading / Error / Empty / Data.
///
/// Day la widget duy nhat ma cac man hinh danh sach (booking, dich vu,
/// nhan su...) nen dung de tranh lap code `.when(loading:, error:, data:)`
/// va tu ve them logic empty-check o tung noi.
///
/// Vi du su dung trong 1 Screen:
/// ```dart
/// final servicesAsync = ref.watch(serviceListProvider);
/// return AsyncValueWidget<List<ServiceModel>>(
///   value: servicesAsync,
///   skeletonItemCount: 5,
///   isEmpty: (list) => list.isEmpty,
///   emptyTitle: 'Chưa có dịch vụ nào',
///   onRetry: () => ref.invalidate(serviceListProvider),
///   dataBuilder: (services) => ServiceListView(services: services),
/// );
/// ```
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    required this.value,
    required this.dataBuilder,
    required this.onRetry,
    this.isEmpty,
    this.emptyTitle = 'Chưa có dữ liệu',
    this.emptyDescription,
    this.emptyCtaLabel,
    this.onEmptyCtaPressed,
    this.skeletonItemCount = 4,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) dataBuilder;
  final VoidCallback onRetry;

  /// Tra ve true neu du lieu ben trong [T] duoc coi la "rong" (vd:
  /// `(list) => list.isEmpty`). De null neu [T] khong bao gio co Empty State.
  final bool Function(T data)? isEmpty;

  final String emptyTitle;
  final String? emptyDescription;
  final String? emptyCtaLabel;
  final VoidCallback? onEmptyCtaPressed;
  final int skeletonItemCount;

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: () => SkeletonLoading(itemCount: skeletonItemCount),
      error: (Object error, StackTrace stackTrace) {
        final String message = error is Failure ? error.message : 'Đã có lỗi xảy ra.';
        return ErrorStateWidget(message: message, onRetry: onRetry);
      },
      data: (T data) {
        if (isEmpty != null && isEmpty!(data)) {
          return EmptyStateWidget(
            title: emptyTitle,
            description: emptyDescription,
            ctaLabel: emptyCtaLabel,
            onCtaPressed: onEmptyCtaPressed,
          );
        }
        return dataBuilder(data);
      },
    );
  }
}
