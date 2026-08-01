import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:barberbook_app/app.dart';
import 'package:barberbook_app/core/config/app_config.dart';
import 'package:barberbook_app/core/providers/shared_preferences_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khoi tao truoc cac dependency bat buoc phai co san khi app frame dau
  // tien duoc ve (ca 2 deu la async nen phai await o day).
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  // BAT BUOC khoi tao Supabase TRUOC khi goi runApp() - moi noi trong app
  // dung `Supabase.instance.client` (qua `supabaseClientProvider`) deu gia
  // dinh Supabase da san sang. Neu thieu SUPABASE_URL/SUPABASE_ANON_KEY khi
  // build, dong nay se throw loi ro rang ngay khi mo app thay vi loi mo ho
  // luc goi API sau nay.
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: AppConfig.enableNetworkLogging,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const App(),
    ),
  );
}