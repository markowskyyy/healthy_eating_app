abstract class AnalyticsService {
  void logEvent(String name, {Map<String, dynamic>? parameters});
  void logError(String message, {Object? error, StackTrace? stackTrace});
  void logUnhandledException(Object error, StackTrace stackTrace);
}