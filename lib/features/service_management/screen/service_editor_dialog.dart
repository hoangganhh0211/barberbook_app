import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/core/theme/app_colors.dart';
import 'package:barberbook_app/features/service_management/model/service_admin_item.dart';

class ServiceEditorDialog extends StatefulWidget {
  const ServiceEditorDialog({
    required this.onSave,
    this.service,
    super.key,
  });

  final ServiceAdminItem? service;
  final Future<void> Function(ServiceFormData data) onSave;

  @override
  State<ServiceEditorDialog> createState() => _ServiceEditorDialogState();
}

class _ServiceEditorDialogState extends State<ServiceEditorDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _imageUrlController;
  bool _saving = false;
  String? _errorMessage;

  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    final ServiceAdminItem? service = widget.service;
    _nameController = TextEditingController(text: service?.name ?? '');
    _descriptionController =
        TextEditingController(text: service?.description ?? '');
    _priceController =
        TextEditingController(text: service?.price.round().toString() ?? '');
    _durationController = TextEditingController(
      text: service?.durationMinutes.toString() ?? '30',
    );
    _imageUrlController = TextEditingController(text: service?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ServiceFormData data = ServiceFormData(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      durationMinutes: int.parse(_durationController.text.trim()),
      imageUrl: _imageUrlController.text.trim(),
    );

    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    try {
      await widget.onSave(data);
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _errorMessage = error is PostgrestException
            ? error.message
            : error is StateError
                ? error.message
                : 'Không thể lưu dịch vụ. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Chỉnh sửa dịch vụ' : 'Thêm dịch vụ mới'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Tên dịch vụ *',
                    hintText: 'Ví dụ: Cắt tóc nam',
                    prefixIcon: Icon(Icons.content_cut),
                  ),
                  maxLength: 80,
                  validator: (value) {
                    if ((value ?? '').trim().isEmpty)
                      return 'Vui lòng nhập tên dịch vụ.';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    hintText: 'Mô tả ngắn về dịch vụ (không bắt buộc)',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  maxLength: 500,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ) *',
                    hintText: 'Ví dụ: 100000',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                  validator: (value) {
                    final int? price = int.tryParse((value ?? '').trim());
                    if (price == null || price <= 0)
                      return 'Giá phải là số lớn hơn 0.';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Thời lượng (phút) *',
                    hintText: 'Ví dụ: 30',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  validator: (value) {
                    final int? duration = int.tryParse((value ?? '').trim());
                    if (duration == null || duration < 5 || duration > 600) {
                      return 'Thời lượng phải từ 5 đến 600 phút.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.error.withOpacity(0.35)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Hủy'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined),
          label: Text(_saving ? 'Đang lưu...' : 'Lưu dịch vụ'),
        ),
      ],
    );
  }
}
