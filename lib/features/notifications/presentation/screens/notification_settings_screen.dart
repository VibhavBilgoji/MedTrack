import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  bool _enabled = true;
  bool _notify30 = true;
  bool _notify7 = true;
  bool _notifyDay = true;
  bool _dailySummary = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notifications)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Master toggle
          _SettingCard(
            isDark: isDark,
            child: SwitchListTile(
              title: const Text('Enable All Reminders', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              subtitle: const Text('Receive medicine expiry notifications'),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
              activeThumbColor: AppColors.primary,
              secondary: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 22),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          Text('Reminder Schedule', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // 30 days
          _SettingCard(
            isDark: isDark,
            child: SwitchListTile(
              title: const Text(AppStrings.reminder30),
              value: _notify30 && _enabled,
              onChanged: _enabled ? (v) => setState(() => _notify30 = v) : null,
              activeThumbColor: AppColors.safe,
              secondary: const Icon(Icons.calendar_month_rounded, color: AppColors.safe),
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 10),
          // 7 days
          _SettingCard(
            isDark: isDark,
            child: SwitchListTile(
              title: const Text(AppStrings.reminder7),
              value: _notify7 && _enabled,
              onChanged: _enabled ? (v) => setState(() => _notify7 = v) : null,
              activeThumbColor: AppColors.warning,
              secondary: const Icon(Icons.access_time_rounded, color: AppColors.warning),
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          const SizedBox(height: 10),
          // On expiry day
          _SettingCard(
            isDark: isDark,
            child: SwitchListTile(
              title: const Text(AppStrings.reminderOnDay),
              value: _notifyDay && _enabled,
              onChanged: _enabled ? (v) => setState(() => _notifyDay = v) : null,
              activeThumbColor: AppColors.critical,
              secondary: const Icon(Icons.warning_amber_rounded, color: AppColors.critical),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 10),
          // Daily summary
          _SettingCard(
            isDark: isDark,
            child: SwitchListTile(
              title: const Text(AppStrings.dailySummary),
              subtitle: const Text('Receive a summary at 8:00 PM every day'),
              value: _dailySummary && _enabled,
              onChanged: _enabled ? (v) => setState(() => _dailySummary = v) : null,
              activeThumbColor: AppColors.primary,
              secondary: const Icon(Icons.summarize_rounded, color: AppColors.primary),
            ),
          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
          const SizedBox(height: 24),
          // Info card
          const _InfoCard(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Preferences saved!'), backgroundColor: AppColors.safe),
              );
            },
            child: const Text('Save Preferences'),
          ).animate().fadeIn(delay: 350.ms),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final Widget child;
  final bool isDark;
  const _SettingCard({required this.child, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
    ),
    child: child,
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Notifications are sent via Firebase Cloud Messaging. Per-medicine overrides can be set when adding or editing any medicine.',
              style: TextStyle(color: AppColors.primaryDark, fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }
}
