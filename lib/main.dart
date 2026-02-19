import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/app/app_initializers.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/core/router/app_router.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:healthy_eating_app/presentation/providers/providers.dart';

void main() async {
  AppMetrica.runZoneGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await loadEnv();
    await initFirebase();

    final canTrack = await initTracking();
    final appsFlyerSdk = await initAppsFlyer();

    await initAppHud(appsFlyerSdk);
    await initAppMetrica();
    await preloadAppHud();
    runApp(
      ProviderScope(
        overrides: [
          /// прокидываем canTrack
          canTrackProvider.overrideWithValue(canTrack),

          /// прокидываем AppsFlyer SDK
          appsFlyerSdkProvider.overrideWithValue(appsFlyerSdk),
        ],
        child: const MyApp(),
      ),
    );
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