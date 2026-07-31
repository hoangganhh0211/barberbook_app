import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barberbook_app/app.dart';
import 'package:barberbook_app/core/providers/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khoi tao truoc cac dependency bat buoc phai co san khi app frame dau
  // tien duoc ve (SharedPreferences la async nen phai await o day, xem
  // giai thich trong `shared_preferences_provider.dart`).
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}
