import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

class AnalyticsHub {
  final Map<AnalyticsProvider, AnalyticsService> _services;

  // Задача класса зависимости от providers отправлять логи в разные инструменты аналитики

  AnalyticsHub(List<AnalyticsService> services)
      : _services = {
    for (final service in services) service.providerType: service,
  };

  void logEvent(
      String name, {
        Map<String, dynamic>? parameters,
        Set<AnalyticsProvider>? providers,
      }) {
    final targets = providers ?? _services.keys;
    for (final provider in targets) {
      _services[provider]?.logEvent(name, parameters: parameters);
    }
  }

  void logError(
      String message, {
        Object? error,
        StackTrace? stackTrace,
        Set<AnalyticsProvider>? providers,
      }) {
    final targets = providers ?? _services.keys;
    for (final provider in targets) {
      _services[provider]?.logError(
        message,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void logUnhandledException(
      Object error,
      StackTrace stackTrace, {
        Set<AnalyticsProvider>? providers,
      }) {
    final targets = providers ?? _services.keys;
    for (final provider in targets) {
      _services[provider]?.logUnhandledException(error, stackTrace);
    }
  }
}
