import 'package:flutter/material.dart';

import 'package:barberbook_app/core/widgets/branded_app_bar.dart';

/// PLACEHOLDER dung TAM THOI cho cac tab/man hinh chua duoc xay dung o
/// Sprint hien tai. Moi Sprint sau se thay tung cai bang Screen that cua
/// dung feature do (vd: `HomeCustomerScreen`, `SearchScreen`...) va XOA
/// import widget nay khoi route tuong ung - khong duoc de sot lai o code
/// production cuoi cung.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.appBar = const BrandedAppBar(),
    super.key,
  });

  final String title;

  /// Mac dinh la `BrandedAppBar(variant: logoCentered)` - dung cho MOI man
  /// GOC cua tab (Home/Dat lich/Tiem/Thong bao/Thong tin, Dashboard/Lich
  /// lam viec/Nhan su/Dich vu/Ca nhan) vi day la Header variant 1 trong
  /// Figma (logo can giua, KHONG co nut back - vi khong co man truoc do de
  /// quay lai). Cac man CON duoc push tu ben trong 1 tab (vd: Chi tiet
  /// Tiem o Sprint 2) se tu truyen `appBar` khac (vd: `BrandedAppBar(variant:
  /// titleOnly, showBackButton: true)` hoac AppBar rieng cua man do).
  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Text(
          '$title\n(sẽ được xây dựng ở Sprint tương ứng)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
