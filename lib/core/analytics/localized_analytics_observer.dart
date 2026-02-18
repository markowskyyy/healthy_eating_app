import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class LocalizedAnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  final FirebaseAnalytics analytics;

  LocalizedAnalyticsObserver({required this.analytics});

  @override
  void didPush(Route route, Route? previousRoute) {
    print('didPush');
    super.didPush(route, previousRoute);
    _sendScreenView(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    print('didReplace');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _sendScreenView(newRoute);
  }

  @override
  void didChangeNext(Route? nextRoute, Route? previousRoute) {
    print('didChangeNext');
    if (nextRoute != null) _sendScreenView(nextRoute);
    // super.didChangeNext(nextRoute, previousRoute);
  }

  void _sendScreenView(Route route) {
    final settings = route.settings;
    String? screenName = settings.name;

    const mapping = {
      'home': 'Главная',
      'recommendations': 'Рекомендации',
      'about': 'О приложении',
    };

    final displayName = mapping[screenName] ?? screenName;

    if (displayName != null) {
      analytics.logScreenView(
        screenName: displayName,
        screenClass: route.runtimeType.toString(),
      );
    }
  }
}