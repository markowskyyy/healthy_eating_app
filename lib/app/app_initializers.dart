import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:apphud/apphud.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_data.dart';
import 'package:apphud/models/apphud_models/apphud_attribution_provider.dart';

Future<void> loadEnv() async {
  await dotenv.load(fileName: '.env');
}

Future<void> initFirebase() async {
  await Firebase.initializeApp();
}

Future<bool> initTracking() async {
  return _checkTrackingAuthorization();
}

Future<AppsflyerSdk> initAppsFlyer() async {
  final sdk = AppsflyerSdk(
    AppsFlyerOptions(
      afDevKey: dotenv.env['APPSFLYER_DEV_KEY']!,
      appId: dotenv.env['APP_ID']!,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 60,
    ),
  );

  sdk.initSdk(registerConversionDataCallback: true);
  return sdk;
}

Future<void> initAppHud(AppsflyerSdk sdk) async {
  await Apphud.start(
    apiKey: dotenv.env['APPHUD_API_KEY']!,
  );

  sdk.onInstallConversionData((data) async {
    final uid = await sdk.getAppsFlyerUID();
    if (uid == null) return;

    await Apphud.setAttribution(
      provider: ApphudAttributionProvider.appsFlyer,
      data: ApphudAttributionData(
        rawData: Map<String, dynamic>.from(data),
      ),
      identifier: uid,
    );
  });
}

Future<void> initAppMetrica() async {
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
}

Future<void> preloadAppHud() async {
  // final placements = await Apphud.placements();
  // final paywall = placements.first.paywall;
  // final products = paywall?.products ?? [];
}

Future<bool> _checkTrackingAuthorization() async {
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      return newStatus == TrackingStatus.authorized;
    }
    return status == TrackingStatus.authorized;
  }
  return true;
}
