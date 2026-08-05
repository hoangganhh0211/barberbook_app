import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/widgets/async_value_widget.dart';
import 'package:barberbook_app/core/widgets/branded_app_bar.dart';
import 'package:barberbook_app/features/search_shop_stylist/provider/shop_provider.dart';
import 'package:barberbook_app/features/search_shop_stylist/widget/shop_list_item.dart';
import 'package:barberbook_app/shared/models/shop_model.dart';

/// Man goc cua tab "Tiem" (US-SEARCH-008 - ban rut gon Sprint 2: tim kiem
/// theo ten, chua co bo loc nang cao - se bo sung sau neu can).
class ShopListScreen extends ConsumerStatefulWidget {
  const ShopListScreen({super.key});

  @override
  ConsumerState<ShopListScreen> createState() => _ShopListScreenState();
}

class _ShopListScreenState extends ConsumerState<ShopListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  /// Debounce 400ms - tranh goi API Supabase lien tuc theo tung ky tu go,
  /// chi goi khi nguoi dung NGUNG go trong 400ms.
  void _onSearchChanged(String value) {
    setState(() {}); // cap nhat ngay icon "x" xoa tim kiem, khong can doi debounce
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _searchQuery = value.trim());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ShopModel>> shopsAsync = ref.watch(shopListProvider(_searchQuery));

    return Scaffold(
      appBar: const BrandedAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm tiệm theo tên...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      ),
              ),
            ),
          ),
          Expanded(
            child: AsyncValueWidget<List<ShopModel>>(
              value: shopsAsync,
              skeletonItemCount: 5,
              isEmpty: (shops) => shops.isEmpty,
              emptyTitle: _searchQuery.isEmpty ? 'Chưa có tiệm nào' : 'Không tìm thấy tiệm phù hợp',
              emptyDescription: _searchQuery.isEmpty ? null : 'Thử tìm với từ khoá khác',
              onRetry: () => ref.invalidate(shopListProvider(_searchQuery)),
              dataBuilder: (shops) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: shops.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => ShopListItem(
                  shop: shops[index],
                  onTap: () {
                    // TODO(Sprint2-chuc-nang-4): push toi man Chi tiet Tiem,
                    // truyen shops[index].id.
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}