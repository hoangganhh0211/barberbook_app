import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:barberbook_app/core/theme/app_theme.dart';
import 'package:barberbook_app/routes/app_router.dart';

/// Widget goc cua toan app.
///
/// KHONG dat logic nghiep vu o day - `App` chi chiu trach nhiem wiring
/// Theme + Router + Localization. Moi logic khac thuoc ve Provider/Repository
/// cua tung feature.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'BarberBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // Ep Dark Mode theo dung brand identity trong Figma (khong phu thuoc
      // cai dat he thong cua may nguoi dung). Neu sau nay co yeu cau Light
      // Mode, doi thanh ThemeMode.system va bo sung AppTheme.light.
      themeMode: ThemeMode.dark,
      routerConfig: router,
      // i18n: mac dinh Tieng Viet, du san cho da ngon ngu sau nay (US-NOTIFY-012
      // yeu cau message mapping tu locale.json - se hoan thien khi can da ngon ngu).
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
