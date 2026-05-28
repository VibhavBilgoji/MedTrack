import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/expiry_risk_engine.dart';
import '../../domain/entities/medicine_entity.dart';
import '../controllers/medicine_controller.dart';

class MedicineDetailScreen extends ConsumerWidget {
  final MedicineEntity medicine;
  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final m = medicine;
    final statusColor = _statusColor(m.status);
    final fmt = DateFormat('dd MMM yyyy');

    return Scaffold(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      body: CustomScrollView(
        slivers: [
          // ── Hero App Bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit',
                onPressed: () => context.push(AppRoutes.editMedicine, extra: m),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.critical,
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, ref, m),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Status icon container
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                          ),
                          child: Icon(
                            _categoryIcon(m.category),
                            color: statusColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.category,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(AppSizes.radiusFull),
                            border: Border.all(
                                color: statusColor.withOpacity(0.4)),
                          ),
                          child: Text(
                            m.status.label,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Expiry countdown card
                _ExpiryCountdownCard(medicine: m, statusColor: statusColor)
                    .animate()
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 16),

                // Dates info card
                _InfoCard(
                  title: 'Dates',
                  icon: Icons.calendar_month_rounded,
                  children: [
                    _InfoRow(
                      label: 'Expiry Date',
                      value: fmt.format(m.expiryDate),
                      valueColor: statusColor,
                    ),
                    if (m.manufacturingDate != null)
                      _InfoRow(
                        label: 'Manufactured',
                        value: fmt.format(m.manufacturingDate!),
                      ),
                    if (m.shelfLifeMonths != null)
                      _InfoRow(
                        label: 'Shelf Life',
                        value: '${m.shelfLifeMonths} months',
                      ),
                    if (m.batchNumber != null && m.batchNumber!.isNotEmpty)
                      _InfoRow(label: 'Batch No.', value: m.batchNumber!),
                  ],
                ).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 16),

                // Dosage schedule card
                if (m.dosageAmount != null || m.timesPerDay > 0)
                  _InfoCard(
                    title: 'Dosage & Schedule',
                    icon: Icons.medication_rounded,
                    children: [
                      if (m.dosageAmount != null)
                        _InfoRow(label: 'Dose Amount', value: m.dosageAmount!),
                      _InfoRow(
                          label: 'Frequency',
                          value: '${m.timesPerDay}x per day'),
                      _InfoRow(
                        label: 'Reminders',
                        value: m.reminderEnabled ? 'Enabled' : 'Off',
                        valueColor: m.reminderEnabled
                            ? AppColors.safe
                            : AppColors.textSecondary,
                      ),
                      if (m.scheduledTimes.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          children: m.scheduledTimes
                              .map((t) => _TimeChip(time: t))
                              .toList(),
                        ),
                      ],
                    ],
                  ).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 16),

                // Notes
                if (m.notes != null && m.notes!.isNotEmpty)
                  _InfoCard(
                    title: 'Notes',
                    icon: Icons.notes_rounded,
                    children: [
                      Text(
                        m.notes!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 24),

                // Edit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push(AppRoutes.editMedicine, extra: m),
                    icon: const Icon(Icons.edit_rounded, size: 20),
                    label: const Text(
                      'Edit Medicine',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ).animate().fadeIn(delay: 350.ms),

                const SizedBox(height: 12),

                // Delete button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context, ref, m),
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppColors.critical, size: 20),
                    label: const Text(
                      'Delete Medicine',
                      style: TextStyle(
                          color: AppColors.critical,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColors.critical, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppSizes.radiusMd)),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(ExpiryStatus s) {
    return switch (s) {
      ExpiryStatus.safe => AppColors.safe,
      ExpiryStatus.expiringSoon => AppColors.warning,
      ExpiryStatus.critical => AppColors.critical,
      ExpiryStatus.expired => AppColors.expired,
    };
  }

  IconData _categoryIcon(String category) {
    final c = category.toLowerCase();
    if (c.contains('tablet') || c.contains('capsule')) return Icons.medication_rounded;
    if (c.contains('syrup') || c.contains('liquid')) return Icons.local_drink_rounded;
    if (c.contains('injection') || c.contains('vial')) return Icons.vaccines_rounded;
    if (c.contains('ointment') || c.contains('cream')) return Icons.healing_rounded;
    if (c.contains('drop')) return Icons.water_drop_rounded;
    if (c.contains('inhaler') || c.contains('spray')) return Icons.air_rounded;
    if (c.contains('supplement') || c.contains('vitamin')) return Icons.spa_rounded;
    return Icons.medical_services_rounded;
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, MedicineEntity m) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
            'Are you sure you want to delete "${m.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.critical,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(medicineFormControllerProvider.notifier)
          .deleteMedicine(m.userId, m.id);
      if (context.mounted) context.pop();
    }
  }
}

// ── Sub-Widgets ───────────────────────────────────────────────────────────────

class _ExpiryCountdownCard extends StatelessWidget {
  final MedicineEntity medicine;
  final Color statusColor;

  const _ExpiryCountdownCard(
      {required this.medicine, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final days = medicine.daysUntilExpiry;
    final isExpired = medicine.isExpired;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.15),
            statusColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isExpired
                ? Icons.warning_rounded
                : Icons.timer_outlined,
            color: statusColor,
            size: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isExpired
                    ? '${days.abs()} days ago'
                    : '$days days remaining',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                isExpired ? 'This medicine has expired' : 'Until expiry date',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;
  const _TimeChip({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded,
              size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            time,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
