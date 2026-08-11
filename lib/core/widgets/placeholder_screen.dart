import 'package:flutter/material.dart';

import 'package:barberbook_app/core/widgets/branded_app_bar.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.title,
    this.appBar = const BrandedAppBar(),
    super.key,
  });

  final String title;

  final PreferredSizeWidget appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: Text(
          '$title\n(Tính năng đang phát triển)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
