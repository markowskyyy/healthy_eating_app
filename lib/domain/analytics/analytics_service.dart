import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';

abstract class AnalyticsService {
  AnalyticsProvider get providerType;
  void logEvent(String name, {Map<String, dynamic>? parameters});
  void logError(String message, {Object? error, StackTrace? stackTrace});
  void logUnhandledException(Object error, StackTrace stackTrace);
}