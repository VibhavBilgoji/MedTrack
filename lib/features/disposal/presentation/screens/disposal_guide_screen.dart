import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';

class DisposalGuideScreen extends StatelessWidget {
  const DisposalGuideScreen({super.key});

  static const _categories = [
    _DisposalCategory(
      icon: Icons.medication_rounded,
      title: 'Tablets & Capsules',
      color: AppColors.primary,
      steps: [
        'Do NOT flush tablets down the toilet.',
        'Remove from original packaging.',
        'Mix with used coffee grounds or dirt to make undesirable.',
        'Seal in a zip-lock bag and place in household trash.',
        'Look for local medicine take-back programs.',
      ],
      whyItMatters: 'Improperly discarded tablets contaminate groundwater and soil.',
    ),
    _DisposalCategory(
      icon: Icons.water_drop_rounded,
      title: 'Syrups & Liquids',
      color: AppColors.safe,
      steps: [
        'Do NOT pour directly down the drain.',
        'Mix with an undesirable substance like salt or kitty litter.',
        'Place the sealed container in a plastic bag.',
        'Dispose in household garbage.',
        'Check if local pharmacy accepts liquid returns.',
      ],
      whyItMatters: 'Liquid medications can pollute water systems and harm aquatic life.',
    ),
    _DisposalCategory(
      icon: Icons.vaccines_rounded,
      title: 'Injections & Vials',
      color: AppColors.warning,
      steps: [
        'NEVER throw syringes/needles in regular trash.',
        'Use a sharps disposal container (available at pharmacies).',
        'Seal the container when 3/4 full.',
        'Take to a sharps drop-off location.',
        'DO NOT recap needles.',
      ],
      whyItMatters: 'Needlestick injuries can spread serious infections.',
    ),
    _DisposalCategory(
      icon: Icons.air_rounded,
      title: 'Inhalers & Sprays',
      color: AppColors.critical,
      steps: [
        'Check if your inhaler brand offers a return program.',
        'Many inhalers contain greenhouse gases — do not puncture.',
        'Take to a pharmacy or inhaler recycling point.',
        'Never throw into fire or incinerator.',
      ],
      whyItMatters: 'Aerosol propellants in inhalers contribute to climate change.',
    ),
    _DisposalCategory(
      icon: Icons.healing_rounded,
      title: 'Patches & Creams',
      color: AppColors.expired,
      steps: [
        'Fold used patches in half (adhesive sides together).',
        'Flush used patches if they contain opioids (WHO guideline).',
        'Unused patches: mix into dirt/coffee in sealed bag, discard.',
        'For creams: remove from tube, mix with dirt, double-bag.',
      ],
      whyItMatters: 'Drug patches still contain active substances after use.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Disposal Guide'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Chip(
              label: Text('WHO Guidelines', style: TextStyle(fontSize: 11)),
              avatar: Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
              backgroundColor: AppColors.primaryContainer,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // Hero banner
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: Row(
              children: [
                const Icon(Icons.recycling_rounded, color: Colors.white, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dispose Responsibly', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                      const SizedBox(height: 4),
                      Text('Protect communities and the environment', style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          ..._categories.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _DisposalCard(category: entry.value)
                .animate()
                .fadeIn(delay: (entry.key * 80).ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0),
          )),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.safeContainer,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: AppColors.safe, size: 20),
                    SizedBox(width: 8),
                    Text('Find a Take-Back Program', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
                SizedBox(height: 8),
                Text('Many pharmacies and hospitals offer free medicine returns. Contact your local health authority for a certified disposal point near you.', style: TextStyle(fontSize: 13, height: 1.5)),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }
}

class _DisposalCategory {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> steps;
  final String whyItMatters;
  const _DisposalCategory({required this.icon, required this.title, required this.color, required this.steps, required this.whyItMatters});
}

class _DisposalCard extends StatefulWidget {
  final _DisposalCategory category;
  const _DisposalCard({required this.category});

  @override
  State<_DisposalCard> createState() => _DisposalCardState();
}

class _DisposalCardState extends State<_DisposalCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final c = widget.category;

    return AnimatedContainer(
      duration: 300.ms,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: c.color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(c.icon, color: c.color, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(c.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                  Icon(_expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...c.steps.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(color: c.color, shape: BoxShape.circle),
                          child: Center(child: Text('${e.key + 1}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value, style: const TextStyle(fontSize: 13, height: 1.5))),
                      ],
                    ),
                  )),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: c.color.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb_outline_rounded, color: c.color, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(c.whyItMatters, style: TextStyle(color: c.color, fontSize: 12, height: 1.4))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
