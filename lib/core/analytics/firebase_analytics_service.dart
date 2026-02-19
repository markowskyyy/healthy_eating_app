import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_provider.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

class FirebaseAnalyticsService implements AnalyticsService {
  final bool canTrack;
  final FirebaseAnalytics _analytics;

  @override
  AnalyticsProvider get providerType => AnalyticsProvider.firebase;

  FirebaseAnalyticsService({
    required this.canTrack,
    FirebaseAnalytics? analytics
  })
    : _analytics = analytics ?? FirebaseAnalytics.instance;

  @override
  void logEvent(String name, {Map<String, dynamic>? parameters}) {
    if (!canTrack) return;
    _analytics.logEvent(name: name, parameters: parameters?.cast<String, Object>());
  }

  @override
  void logError(String message, {Object? error, StackTrace? stackTrace}) {
    if (!canTrack) return;
    _analytics.logEvent(
      name: 'error',
      parameters: {
        'message': message,
        if (error != null) 'error': error.toString(),
        if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      },
    );
  }

  @override
  void logUnhandledException(Object error, StackTrace stackTrace) {
    if (!canTrack) return;
    _analytics.logEvent(
      name: 'unhandled_exception',
      parameters: {
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
      },
    );
  }
}