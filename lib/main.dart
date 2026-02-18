import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/core/router/app_router.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';

void main() async {

  AppMetrica.runZoneGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
    await Firebase.initializeApp();

    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();

        print("ATT status after request: $newStatus");
      } else {
        print("ATT current status: $status");
      }
    }

    final appsflyerSdk = AppsflyerSdk(
        AppsFlyerOptions(
            afDevKey: 'GAgckFyN4yETigBtP4qtRG',
            appId: '6749377146',
            showDebug: true,
            timeToWaitForATTUserAuthorization: 60
        )
    );

    appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
    );


    // await AppHud.start(apiKey: 'app_Z44sHCCXqhP5FCBDa8SxKBLB7VLpga');


    final apiKey = dotenv.env['APPMETRICA_API_KEY']!;
    await AppMetrica.activate(
      AppMetricaConfig(
          apiKey,
          flutterCrashReporting: true,
          logs: true,
          crashReporting: true,
          firstActivationAsUpdate: false,
      ),
    );
    await AppMetrica.reportEvent('Open app event');

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

Future<void> handleATT() async {
  final status =
  await AppTrackingTransparency.trackingAuthorizationStatus;

  switch (status) {
    case TrackingStatus.authorized:
      print("User allowed tracking");
      break;

    case TrackingStatus.denied:
      print("User denied tracking");
      break;

    case TrackingStatus.restricted:
      print("Tracking restricted");
      break;

    case TrackingStatus.notDetermined:
      print("Not determined");
      break;

    case TrackingStatus.notSupported:
      print("Not supported");
      break;
  }
}
