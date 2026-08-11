import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/core/theme/app_text_styles.dart';
import 'package:barberbook_app/core/utils/result.dart';
import 'package:barberbook_app/core/widgets/app_primary_button.dart';
import 'package:barberbook_app/features/review/provider/review_provider.dart';
import 'package:barberbook_app/features/review/widget/star_rating.dart';
Future<bool?> showWriteReviewSheet(
  BuildContext context, {
  required String bookingId,
  required String shopId,
  required String shopName,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _WriteReviewSheetContent(
      bookingId: bookingId,
      shopId: shopId,
      shopName: shopName,
    ),
  );
}

class _WriteReviewSheetContent extends ConsumerStatefulWidget {
  const _WriteReviewSheetContent({
    required this.bookingId,
    required this.shopId,
    required this.shopName,
  });

  final String bookingId;
  final String shopId;
  final String shopName;

  @override
  ConsumerState<_WriteReviewSheetContent> createState() => _WriteReviewSheetContentState();
}

class _WriteReviewSheetContentState extends ConsumerState<_WriteReviewSheetContent> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    final result = await ref.read(reviewRepositoryProvider).createReview(
          bookingId: widget.bookingId,
          shopId: widget.shopId,
          rating: _rating,
          comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    switch (result) {
      case Success():
        ref.invalidate(reviewListProvider(widget.shopId));
        if (context.mounted) Navigator.of(context).pop(true);
      case ResultFailure(:final failure):
        _showError(failure.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppColors.error));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Text('Đánh giá ${widget.shopName}', style: AppTextStyles.heading2, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          StarRatingInput(rating: _rating, onChanged: (value) => setState(() => _rating = value)),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Chia sẻ trải nghiệm của bạn (không bắt buộc)...',
            ),
          ),
          const SizedBox(height: 20),
          AppPrimaryButton(
            label: 'Gửi đánh giá',
            isLoading: _isSubmitting,
            onPressed: _rating > 0 ? _handleSubmit : null,
          ),
        ],
      ),
    );
  }
}