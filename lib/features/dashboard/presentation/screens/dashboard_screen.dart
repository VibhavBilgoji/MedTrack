import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/expiry_risk_engine.dart';
import '../../../medicines/domain/entities/medicine_entity.dart';
import '../../../medicines/presentation/controllers/medicine_controller.dart';
import '../../../medicines/presentation/widgets/medicine_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return authAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        return _DashboardContent(user: user, isDark: isDark);
      },
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final dynamic user;
  final bool isDark;
  const _DashboardContent({required this.user, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(medicinesStreamProvider(user.id));
    final stats = ref.watch(dashboardStatsProvider(user.id));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(medicinesStreamProvider(user.id)),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, user),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 20),
                  _StatsRow(stats: stats).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 24),
                  _RiskScoreCard(stats: stats).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 24),
                  _CategoryPieChart(stats: stats).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 24),
                  _MonthlyTrendChart(stats: stats).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 24),
                  _UpcomingExpirations(medicinesAsync: medicinesAsync)
                      .animate().fadeIn(delay: 400.ms),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addMedicine),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Medicine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ).animate().scale(delay: 600.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, dynamic user) {
    return SliverAppBar(
      floating: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Hello, ${user.name.split(' ').first} 👋',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text('Here\'s your medicine overview',
                      style: TextStyle(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: 14,
                      )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    color: AppColors.primary,
                    iconSize: 28,
                    onPressed: () => context.push(AppRoutes.scanner),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => context.push(AppRoutes.notifications),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final DashboardStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'Total', value: stats.total, color: AppColors.primary, icon: Icons.medication_rounded),
        const SizedBox(width: 12),
        _StatCard(label: 'Safe', value: stats.safe, color: AppColors.safe, icon: Icons.check_circle_rounded),
        const SizedBox(width: 12),
        _StatCard(label: 'Warning', value: stats.expiringSoon + stats.critical, color: AppColors.warning, icon: Icons.warning_rounded),
        const SizedBox(width: 12),
        _StatCard(label: 'Expired', value: stats.expired, color: AppColors.critical, icon: Icons.cancel_rounded),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value.toString(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ── Risk Score Card ────────────────────────────────────────────────────────────

class _RiskScoreCard extends StatelessWidget {
  final DashboardStats stats;
  const _RiskScoreCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = ExpiryRiskEngine.riskScoreColor(stats.riskScore);
    final label = ExpiryRiskEngine.riskScoreLabel(stats.riskScore);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.12), color.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 44,
            lineWidth: 7,
            percent: (stats.riskScore / 100).clamp(0.0, 1.0),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${stats.riskScore}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
              ],
            ),
            progressColor: color,
            backgroundColor: color.withValues(alpha: 0.15),
            circularStrokeCap: CircularStrokeCap.round,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Expiry Risk Score', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 6),
                Text(
                  'Based on ${stats.total} tracked medicines',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category Pie Chart ─────────────────────────────────────────────────────────

class _CategoryPieChart extends StatefulWidget {
  final DashboardStats stats;
  const _CategoryPieChart({required this.stats});

  @override
  State<_CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<_CategoryPieChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    final entries = widget.stats.byCategory.entries.toList();

    if (entries.isEmpty) {
      return const _EmptyChartCard(title: 'Medicines by Category', message: 'Add medicines to see chart');
    }

    return _ChartCard(
      title: 'Medicines by Category',
      child: Row(
        children: [
          SizedBox(
            width: 140, height: 140,
            child: PieChart(
              PieChartData(
                sections: List.generate(entries.length, (i) {
                  final entry = entries[i];
                  final color = AppColors.chartColors[i % AppColors.chartColors.length];
                  final isTouched = i == _touched;
                  return PieChartSectionData(
                    value: entry.value.toDouble(),
                    color: color,
                    radius: isTouched ? 56 : 48,
                    title: isTouched ? entry.value.toString() : '',
                    titleStyle: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    badgeWidget: null,
                  );
                }),
                pieTouchData: PieTouchData(touchCallback: (event, res) {
                  setState(() {
                    if (!event.isInterestedForInteractions || res?.touchedSection == null) {
                      _touched = -1;
                    } else {
                      _touched = res!.touchedSection!.touchedSectionIndex;
                    }
                  });
                }),
                centerSpaceRadius: 30,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(entries.length, (i) {
                final color = AppColors.chartColors[i % AppColors.chartColors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(entries[i].key, style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis)),
                      Text('${entries[i].value}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Monthly Trend ──────────────────────────────────────────────────────────────

class _MonthlyTrendChart extends StatelessWidget {
  final DashboardStats stats;
  const _MonthlyTrendChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.monthlyExpiry.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    if (entries.isEmpty) return const _EmptyChartCard(title: 'Monthly Expiry Trend', message: 'No data yet');

    final spots = List.generate(entries.length, (i) => FlSpot(i.toDouble(), entries[i].value.toDouble()));
    final labels = entries.map((e) => e.key.substring(5)).toList(); // "MM"

    return _ChartCard(
      title: 'Monthly Expiry Trend',
      child: SizedBox(
        height: 150,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) => FlLine(color: AppColors.borderLight.withValues(alpha: 0.4), strokeWidth: 1),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (v, _) => Text(
                    labels.length > v.toInt() ? labels[v.toInt()] : '',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 24,
                  getTitlesWidget: (v, _) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)),
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: AppColors.primary,
                barWidth: 2.5,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upcoming Expirations ───────────────────────────────────────────────────────

class _UpcomingExpirations extends StatelessWidget {
  final AsyncValue<List<MedicineEntity>> medicinesAsync;
  const _UpcomingExpirations({required this.medicinesAsync});

  @override
  Widget build(BuildContext context) {
    return medicinesAsync.when(
      loading: () => const _ShimmerList(),
      error: (e, _) => Text('Error: $e'),
      data: (medicines) {
        final upcoming = medicines
            .where((m) => !m.isExpired && m.daysUntilExpiry <= 30)
            .toList()
          ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

        if (upcoming.isEmpty) {
          return const _EmptyChartCard(title: 'Upcoming Expirations', message: '✅ No medicines expiring in 30 days');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upcoming Expirations', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...upcoming.take(5).map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MedicineCard(medicine: m, compact: true),
            )),
          ],
        );
      },
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _ChartCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _EmptyChartCard extends StatelessWidget {
  final String title;
  final String message;
  const _EmptyChartCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();
  @override
  Widget build(BuildContext context) {
    return Column(children: List.generate(3, (_) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.borderLight,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
    )));
  }
}
