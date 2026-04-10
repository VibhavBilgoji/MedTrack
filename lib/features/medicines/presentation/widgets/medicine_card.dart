import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../../domain/entities/medicine_entity.dart';

class MedicineCard extends StatelessWidget {
  final MedicineEntity medicine;
  final bool compact;
  final VoidCallback? onTap;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final status = medicine.status;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final daysLeft = medicine.daysUntilExpiry;

    return InkWell(
      onTap: onTap ?? () => context.push(AppRoutes.medicineDetail, extra: medicine),
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(
            color: status.color.withValues(alpha: compact ? 0.4 : 0.25),
            width: compact ? 1 : 1.5,
          ),
        ),
        child: Row(
          children: [
            // Status indicator
            Container(
              width: compact ? 44 : 52,
              height: compact ? 44 : 52,
              decoration: BoxDecoration(
                color: status.containerColor,
                borderRadius: BorderRadius.circular(compact ? 10 : 14),
              ),
              child: Icon(status.icon, color: status.color, size: compact ? 22 : 26),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: compact ? 14 : 16,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    medicine.category,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Exp: ${medicine.expiryDate.display}',
                      style: TextStyle(fontSize: 12, color: status.color, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            // Badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: status.containerColor,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(
                    medicine.isExpired
                        ? 'Expired'
                        : daysLeft == 0
                            ? 'Today'
                            : '${daysLeft}d',
                    style: TextStyle(
                      color: status.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  Icon(Icons.chevron_right_rounded,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted, size: 18),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
