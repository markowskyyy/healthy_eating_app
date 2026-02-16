import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthy_eating_app/presentation/pages/about_screen.dart';
import 'package:healthy_eating_app/presentation/pages/home_page.dart';
import 'package:healthy_eating_app/presentation/pages/recommendations_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (context, state) => const NoTransitionPage(child: HomePage()),
        ),
        GoRoute(
          path: '/recommendations',
          name: 'recommendations',
          pageBuilder: (context, state) => const NoTransitionPage(child: RecommendationsScreen()),
        ),
        GoRoute(
          path: '/about',
          name: 'about',
          pageBuilder: (context, state) => const NoTransitionPage(child: AboutScreen()),
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(context, index),
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
        break;
      case 1:
        context.go('/recommendations');
        break;
      case 2:
        context.go('/about');
        break;
    }
  }
}