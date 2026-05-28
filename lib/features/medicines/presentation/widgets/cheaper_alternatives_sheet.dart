import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/medicine_database.dart';
import '../../providers/medicine_ai_provider.dart';

class CheaperAlternativesSheet extends ConsumerStatefulWidget {
  final MedicineInfo originalMedicine;
  final List<MedicineInfo> alternatives;
  final ValueChanged<MedicineInfo> onSelectAlternative;

  const CheaperAlternativesSheet({
    super.key,
    required this.originalMedicine,
    required this.alternatives,
    required this.onSelectAlternative,
  });

  static void show(
    BuildContext context, {
    required MedicineInfo originalMedicine,
    required List<MedicineInfo> alternatives,
    required ValueChanged<MedicineInfo> onSelectAlternative,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheaperAlternativesSheet(
        originalMedicine: originalMedicine,
        alternatives: alternatives,
        onSelectAlternative: onSelectAlternative,
      ),
    );
  }

  @override
  ConsumerState<CheaperAlternativesSheet> createState() => _CheaperAlternativesSheetState();
}

class _CheaperAlternativesSheetState extends ConsumerState<CheaperAlternativesSheet> {
  @override
  void initState() {
    super.initState();
    // Trigger AI analysis on open
    Future.microtask(() {
      ref.read(medicineAIProvider.notifier).analyzeAlternatives(
        widget.originalMedicine,
        widget.alternatives,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final aiState = ref.watch(medicineAIProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.savings_outlined, color: AppColors.safe, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cheaper Alternatives',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Same composition as ${widget.originalMedicine.name} (${widget.originalMedicine.composition})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // AI Insights Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark 
                      ? [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)]
                      : [AppColors.primary.withOpacity(0.1), Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: aiState.maybeWhen(
                        analyzingAlternatives: () => const Text('AI is analyzing composition and prices...', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        alternativesSuccess: (advice) => Text(
                          advice.isEmpty ? 'Analyzing alternatives...' : advice,
                          style: const TextStyle(fontSize: 13, height: 1.4, fontStyle: FontStyle.italic),
                        ),
                        error: (msg) => const Text('AI analysis unavailable.', style: TextStyle(fontSize: 13, color: AppColors.critical)),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 2),

              // Alternatives List
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: widget.alternatives.length,
                  itemBuilder: (_, index) {
                    final alt = widget.alternatives[index];
                    final savings = widget.originalMedicine.price - alt.price;
                    final savingsPercent = (savings / widget.originalMedicine.price) * 100;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : AppColors.cardLight,
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    alt.name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.business, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        alt.company,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${alt.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.safe.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Save ₹${savings.toStringAsFixed(2)} (${savingsPercent.round()}%)',
                                          style: const TextStyle(
                                            color: AppColors.safe,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                widget.onSelectAlternative(alt);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Select', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
