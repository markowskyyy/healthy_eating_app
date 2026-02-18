import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';

abstract class ScreenAnalytics {
  Future<void> trackScreen(String screenName);
}

class FirebaseScreenAnalytics implements ScreenAnalytics {
  final FirebaseAnalytics _analytics;

  FirebaseScreenAnalytics(this._analytics);

  @override
  Future<void> trackScreen(String screenName) async {
    print('📊 [Firebase] screen_view: $screenName');

    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenName,
    );
  }

}
