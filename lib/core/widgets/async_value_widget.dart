import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/error/failure.dart';
import 'package:barberbook_app/core/widgets/empty_state_widget.dart';
import 'package:barberbook_app/core/widgets/error_state_widget.dart';
import 'package:barberbook_app/core/widgets/skeleton_loading.dart';

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
