import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../providers/providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/medicines/domain/entities/medicine_entity.dart';
import '../../features/medicines/presentation/screens/add_medicine_screen.dart';
import '../../features/medicines/presentation/screens/medicine_list_screen.dart';
import '../../features/scanner/presentation/screens/scanner_screen.dart';
import '../../features/notifications/presentation/screens/notification_settings_screen.dart';
import '../../features/disposal/presentation/screens/disposal_guide_screen.dart';
import '../../features/family/presentation/screens/family_screen.dart';
import '../../main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.splash;

      if (authState.isLoading) return null;
      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && (state.matchedLocation == AppRoutes.login || state.matchedLocation == AppRoutes.register)) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, builder: (_, __) => const DashboardScreen()),
          GoRoute(path: AppRoutes.medicines, builder: (_, __) => const MedicineListScreen()),
          GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationSettingsScreen()),
          GoRoute(path: AppRoutes.disposal, builder: (_, __) => const DisposalGuideScreen()),
          GoRoute(path: AppRoutes.family, builder: (_, __) => const FamilyScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.addMedicine,
        builder: (_, __) => const AddMedicineScreen(),
      ),
      GoRoute(
        path: AppRoutes.editMedicine,
        builder: (context, state) => AddMedicineScreen(existing: state.extra as MedicineEntity?),
      ),
      GoRoute(
        path: AppRoutes.scanner,
        builder: (_, __) => const ScannerScreen(),
      ),
    ],
  );
});
