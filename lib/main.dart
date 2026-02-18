import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/core/router/app_router.dart';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';

void main() async {
  AppMetrica.runZoneGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    await Firebase.initializeApp();
    final apiKey = dotenv.env['APPMETRICA_API_KEY']!;
    await AppMetrica.activate(
      AppMetricaConfig(
          apiKey,
          flutterCrashReporting: true,  // обязательно для Flutter-ошибок
          logs: true,                    // для отладки (видеть логи в консоли)
          crashReporting: true,           // для нативных ошибок
          firstActivationAsUpdate: false, // важно для новых установок
      ),
    );
    await AppMetrica.reportEvent('Запуск приложения');

    runApp(const ProviderScope(child: MyApp()));
  });

}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Healthy Eating App',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.accent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      routerConfig: router,
    );
  }
}