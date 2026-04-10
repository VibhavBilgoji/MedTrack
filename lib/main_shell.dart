import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_constants.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _selectedIndex(BuildContext context) {
    final loc = GoRouterState.of(context).matchedLocation;
    if (loc.startsWith(AppRoutes.medicines)) return 1;
    if (loc.startsWith(AppRoutes.notifications)) return 2;
    if (loc.startsWith(AppRoutes.disposal)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _selectedIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go(AppRoutes.dashboard); break;
            case 1: context.go(AppRoutes.medicines); break;
            case 2: context.go(AppRoutes.notifications); break;
            case 3: context.go(AppRoutes.disposal); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.medication_outlined), selectedIcon: Icon(Icons.medication_rounded), label: 'Medicines'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), selectedIcon: Icon(Icons.notifications_rounded), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.recycling_outlined), selectedIcon: Icon(Icons.recycling_rounded), label: 'Disposal'),
        ],
      ),
    );
  }
}
