import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_eating_app/presentation/pages/about_screen.dart';
import 'package:healthy_eating_app/presentation/pages/home_page.dart';
import 'package:healthy_eating_app/presentation/pages/recommendations_screen.dart';

final appRouterProvider = Provider<GoRouter> ((ref) {
  final analytics = FirebaseAnalytics.instance;

  return GoRouter(
    initialLocation: '/',
    observers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            ScaffoldWithNavBar(
              analyticFunc: (value){},
              child: child,
            ),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/recommendations',
            name: 'recommendations',
            pageBuilder: (context, state) =>
            const NoTransitionPage(child: RecommendationsScreen()),
          ),
          GoRoute(
            path: '/about',
            name: 'about',
            pageBuilder: (context, state) =>
            const NoTransitionPage(child: AboutScreen()),
          ),
        ],
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  final Function(String) analyticFunc;
  const ScaffoldWithNavBar({
    super.key,
    required this.child,
    required this.analyticFunc
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) {
          _onItemTapped(context, index);
          // analyticFunc(GoRouterState.of(context).uri.path.toString());
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Дневник'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Рекомендации'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'О приложении'),
        ],
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/recommendations')) return 1;
    if (location.startsWith('/about')) return 2;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {

    switch (index) {
      case 0:
        context.go('/');
      case 1:
        context.go('/recommendations');
      case 2:
        context.go('/about');
    }
  }
}