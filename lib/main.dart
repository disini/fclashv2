import 'dart:io';

import 'package:fclashv2/core/core.dart';
import 'package:fclashv2/models/clash/config.dart';
import 'package:fclashv2/pages/root_page.dart';
import 'package:fclashv2/providers/app/settings_provider.dart';
import 'package:fclashv2/providers/clash/config_provider.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:fclashv2/utils/persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Per.init();
  await CoreController.setHomeDir(await getApplicationSupportDirectory());
  final configFileName =
      Per.prefs.getString("ClashConfigPath") ?? "config.yaml";
  ClashConfig.configPath =
      "${(await getApplicationSupportDirectory()).path}$configFileName";
  if (!ClashConfig.didFileExist) {
    print("creating default config file");
    final f = File(ClashConfig.configPath);
    await f.create();
    final content = await rootBundle.loadString("assets/config.yaml");
    await f.writeAsString(content);
    final mmdb = rootBundle.load('assets/country.mmdb');
    File(await getApplicationSupportDirectory())
  }
  await CoreController.setConfig(ClashConfig.configPath);
  await CoreController.startRust("127.0.0.1:${Api.externalApiPort}");
  await CoreController.startService();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsNotifierProvider);
    final _ = ref.watch(clashConfigNotifierProvider);
    return SafeArea(
      child: MaterialApp(
        debugShowMaterialGrid: false,
        locale: Locale("zh", "CN"),
        theme: settings.theme.theme.light,
        darkTheme: settings.theme.theme.dark,
        themeMode: settings.themeMode,
        home: RootPage(),
      ),
    );
  }
}
