import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

class AppMetricaAnalyticsService implements AnalyticsService {
  final bool canTrack;

  @override
  AnalyticsProvider get providerType => AnalyticsProvider.appmetrica;

  AppMetricaAnalyticsService({required this.canTrack});

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    if (!canTrack) return;
    AppMetrica.reportEvent(name);
  }

  @override
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    if (!canTrack) return;
    AppMetrica.reportError(
      message: message,
      errorDescription: AppMetricaErrorDescription(
        stackTrace ?? StackTrace.current,
        type: error?.runtimeType.toString(),
      )
    );
  }

  @override
  void logUnhandledException(Object error, StackTrace stackTrace) {
    if (!canTrack) return;
    final errorDesc = AppMetricaErrorDescription.fromObjectAndStackTrace(
      error,
      stackTrace,
    );
    AppMetrica.reportUnhandledException(errorDesc);
  }

}