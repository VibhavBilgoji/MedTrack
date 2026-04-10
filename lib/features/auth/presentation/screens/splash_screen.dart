import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/providers.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    authState.whenData((user) {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (!context.mounted) return;
        if (user != null) {
          context.go(AppRoutes.dashboard);
        } else {
          context.go(AppRoutes.login);
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 52),
            )
                .animate()
                .scale(begin: const Offset(0.6, 0.6), duration: 600.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 14),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms),
            const SizedBox(height: 64),
            SizedBox(
              width: 36, height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
