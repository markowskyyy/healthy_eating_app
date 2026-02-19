import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

class AppsFlyerAnalyticsService implements AnalyticsService {
  final bool canTrack;
  final AppsflyerSdk _appsflyerSdk;

  @override
  AnalyticsProvider get providerType => AnalyticsProvider.appsflyer;

  AppsFlyerAnalyticsService({required this.canTrack, required AppsflyerSdk appsflyerSdk})
      : _appsflyerSdk = appsflyerSdk;

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    if (!canTrack) return;
    _appsflyerSdk.logEvent(name, parameters);
  }

  @override
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    if (!canTrack) return;
    _appsflyerSdk.logEvent('error', {
      'message': message,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    });
  }

  @override
  void logUnhandledException(Object error, StackTrace stackTrace) {
    if (!canTrack) return;
    _appsflyerSdk.logEvent('unhandled_exception', {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
    });
  }
}