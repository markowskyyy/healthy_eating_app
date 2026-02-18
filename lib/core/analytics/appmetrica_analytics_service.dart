import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

class AppMetricaAnalyticsService implements AnalyticsService {

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    AppMetrica.reportEvent(name);
  }

  @override
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
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
    final errorDesc = AppMetricaErrorDescription.fromObjectAndStackTrace(
      error,
      stackTrace,
    );
    AppMetrica.reportUnhandledException(errorDesc);
  }

}