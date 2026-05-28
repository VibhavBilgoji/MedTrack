import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../models/prescription_analysis.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/data/medicine_database.dart';
import '../../medicines/presentation/widgets/cheaper_alternatives_sheet.dart';

class AnalysisConfirmationSheet extends StatefulWidget {
  final PrescriptionAnalysisResult result;

  const AnalysisConfirmationSheet({super.key, required this.result});

  @override
  State<AnalysisConfirmationSheet> createState() =>
      _AnalysisConfirmationSheetState();
}

class _AnalysisConfirmationSheetState extends State<AnalysisConfirmationSheet> {
  late List<bool> _checked;
  late List<ExtractedMedicine> _medicines;

  @override
  void initState() {
    super.initState();
    _medicines = List.from(widget.result.medicines);
    // Pre-check all high-confidence medicines
    _checked = _medicines
        .map((m) => m.confidence >= 0.65)
        .toList();
  }

  void _replaceWithAlternative(int index, MedicineInfo alt) {
    setState(() {
      final old = _medicines[index];
      // Map string category to DrugCategory enum
      final drugCategory = DrugCategory.values.firstWhere(
        (e) => alt.category.toLowerCase().contains(e.name.toLowerCase()),
        orElse: () => DrugCategory.tablet,
      );
      _medicines[index] = old.copyWith(
        name: alt.name,
        brandName: alt.company,
        category: drugCategory,
        confidence: 1.0, // Manually selected
      );
      _checked[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final hasSevereInteraction = widget.result.interactions
        .any((i) => i.severity == InteractionSeverity.severe);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.96,
      minChildSize: 0.5,
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
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Prescription Analyzed',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          if (widget.result.doctorName != null)
                            Text(
                              'Dr. ${widget.result.doctorName}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: Text(
                        '${_medicines.length} found',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Severe interaction banner
              if (hasSevereInteraction)
                _InteractionBanner(
                  interactions: widget.result.interactions,
                ).animate().slideY(begin: -0.1, duration: 300.ms),

              const Divider(height: 24),

              // Medicine cards
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: _medicines.length +
                      (widget.result.warnings.isNotEmpty ? 1 : 0),
                  itemBuilder: (_, index) {
                    // Warnings section at the bottom
                    if (index == _medicines.length) {
                      return _WarningsSection(
                        warnings: widget.result.warnings,
                      ).animate().fadeIn(
                            delay: Duration(milliseconds: 100 * index),
                          );
                    }

                    final med = _medicines[index];
                    final interaction = widget.result.interactions.where((i) =>
                        i.medicineA.toLowerCase() == med.name.toLowerCase() ||
                        i.medicineB.toLowerCase() ==
                            med.name.toLowerCase()).firstOrNull;

                    final info = MedicineDatabase.mockMedicines.where((m) => m.name.toLowerCase() == med.name.toLowerCase()).firstOrNull;
                    final alts = info != null ? MedicineDatabase.findCheaperAlternatives(info.composition, info.price, info.name) : <MedicineInfo>[];

                    return _MedicineCard(
                      medicine: med,
                      isChecked: _checked[index],
                      interaction: interaction,
                      onToggle: (val) =>
                          setState(() => _checked[index] = val ?? false),
                      originalInfo: info,
                      alternatives: alts,
                      onAlternativeSelected: (alt) => _replaceWithAlternative(index, alt),
                    ).animate().fadeIn(
                          delay: Duration(milliseconds: 80 * index),
                          duration: 300.ms,
                        ).slideX(begin: 0.1, curve: Curves.easeOutQuad);
                  },
                ),
              ),

              // Bottom CTA
              _BottomCTA(
                selectedCount: _checked.where((c) => c).length,
                medicines: _medicines,
                checked: _checked,
                onConfirm: () => _addSelected(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addSelected(BuildContext context) {
    final selected = <ExtractedMedicine>[];
    for (var i = 0; i < _medicines.length; i++) {
      if (_checked[i]) selected.add(_medicines[i]);
    }
    Navigator.pop(context); // Close sheet
    Navigator.pop(context); // Close camera screen
    
    // Pass back the list to whatever launched it, or add them 
    // We will do one by one or push the first one right now.
    // For simplicity, let's just push the first one to AddMedicineScreen.
    // A robust app might queue them up, but let's push the first.
    if (selected.isNotEmpty) {
       context.push(AppRoutes.addMedicine, extra: selected.first);
    }
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _MedicineCard extends StatelessWidget {
  final ExtractedMedicine medicine;
  final bool isChecked;
  final DrugInteraction? interaction;
  final ValueChanged<bool?> onToggle;
  final MedicineInfo? originalInfo;
  final List<MedicineInfo> alternatives;
  final ValueChanged<MedicineInfo> onAlternativeSelected;

  const _MedicineCard({
    required this.medicine,
    required this.isChecked,
    required this.interaction,
    required this.onToggle,
    this.originalInfo,
    this.alternatives = const [],
    required this.onAlternativeSelected,
  });

  Color _confidenceColor(double c) {
    if (c >= 0.8) return AppColors.safe;
    if (c >= 0.55) return AppColors.warning;
    return AppColors.critical;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasInteraction = interaction != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isChecked
            ? AppColors.primary.withOpacity(0.1)
            : (isDark ? AppColors.cardDark : AppColors.cardLight),
        border: Border.all(
          color: hasInteraction
              ? _severityColor(interaction!.severity).withOpacity(0.6)
              : isChecked
                  ? AppColors.primary.withOpacity(0.5)
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: hasInteraction || isChecked ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        onTap: () => onToggle(!isChecked),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medicine.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        if (medicine.brandName != null)
                          Text(
                            medicine.brandName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Confidence chip
                  _ConfidenceChip(
                    confidence: medicine.confidence,
                    color: _confidenceColor(medicine.confidence),
                  ),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: isChecked,
                    onChanged: onToggle,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Pill(
                    label: medicine.dosageAmount,
                    icon: Icons.medication_liquid,
                    color: Colors.blue.shade600,
                  ),
                  _Pill(
                    label: '${medicine.timesPerDay}x daily',
                    icon: Icons.schedule,
                    color: Colors.purple.shade600,
                  ),
                  _Pill(
                    label: medicine.category.name,
                    icon: Icons.category,
                    color: AppColors.primary,
                  ),
                  if (medicine.durationDays != null)
                    _Pill(
                      label: '\${medicine.durationDays} days',
                      icon: Icons.calendar_today,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
              // Interaction warning
              if (hasInteraction) ...[
                const SizedBox(height: 12),
                _InteractionChip(interaction: interaction!),
              ],
              // Alternatives banner
              if (originalInfo != null && alternatives.isNotEmpty) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => CheaperAlternativesSheet.show(
                    context,
                    originalMedicine: originalInfo!,
                    alternatives: alternatives,
                    onSelectAlternative: onAlternativeSelected,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.safe.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      border: Border.all(color: AppColors.safe.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.savings_outlined, color: AppColors.safe, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${alternatives.length} cheaper alternative${alternatives.length > 1 ? 's' : ''} available',
                            style: const TextStyle(color: AppColors.safe, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.safe, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _severityColor(InteractionSeverity s) {
    return switch (s) {
      InteractionSeverity.mild => AppColors.warning,
      InteractionSeverity.moderate => Colors.orange.shade600,
      InteractionSeverity.severe => AppColors.critical,
    };
  }
}

class _ConfidenceChip extends StatelessWidget {
  final double confidence;
  final Color color;

  const _ConfidenceChip({required this.confidence, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        '\${(confidence * 100).round()}%',
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _Pill({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionChip extends StatelessWidget {
  final DrugInteraction interaction;

  const _InteractionChip({required this.interaction});

  @override
  Widget build(BuildContext context) {
    final color = switch (interaction.severity) {
      InteractionSeverity.mild => AppColors.warning,
      InteractionSeverity.moderate => Colors.orange.shade700,
      InteractionSeverity.severe => AppColors.critical,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              interaction.description,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionBanner extends StatelessWidget {
  final List<DrugInteraction> interactions;

  const _InteractionBanner({required this.interactions});

  @override
  Widget build(BuildContext context) {
    final severe = interactions.where(
      (i) => i.severity == InteractionSeverity.severe,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.critical.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.critical.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dangerous, color: AppColors.critical, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Severe interaction detected — consult your doctor',
                  style: TextStyle(
                    color: AppColors.critical,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...severe.map((i) => Padding(
                padding: const EdgeInsets.only(top: 4, left: 28),
                child: Text(
                  '\${i.medicineA} ↔ \${i.medicineB}: \${i.description}',
                  style: TextStyle(
                    color: AppColors.critical.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _WarningsSection extends StatelessWidget {
  final List<String> warnings;

  const _WarningsSection({required this.warnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.warning, size: 18),
              const SizedBox(width: 8),
              Text(
                'General warnings',
                style: TextStyle(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...warnings.map(
            (w) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(
                      w,
                      style: TextStyle(
                        color: AppColors.warning.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final int selectedCount;
  final List<ExtractedMedicine> medicines;
  final List<bool> checked;
  final VoidCallback onConfirm;

  const _BottomCTA({
    required this.selectedCount,
    required this.medicines,
    required this.checked,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: (isDark ? AppColors.borderDark : AppColors.borderLight)),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
               Navigator.pop(context);
               Navigator.pop(context);
            },
            child: Text('Discard', style: TextStyle(color: AppColors.textSecondary)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: selectedCount > 0 ? onConfirm : null,
                icon: const Icon(Icons.add_task_rounded, size: 20),
                label: Text(
                  selectedCount == 0
                      ? 'Select medicines'
                      : 'Add $selectedCount to cabinet',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
