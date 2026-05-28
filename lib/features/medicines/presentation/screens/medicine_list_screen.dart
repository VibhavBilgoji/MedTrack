import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/expiry_risk_engine.dart';
import '../../domain/entities/medicine_entity.dart';
import '../controllers/medicine_controller.dart';
import '../../../prescription_analyzer/models/prescription_analysis.dart';
import '../widgets/medicine_card.dart';

class MedicineListScreen extends ConsumerStatefulWidget {
  const MedicineListScreen({super.key});

  @override
  ConsumerState<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends ConsumerState<MedicineListScreen> {
  String? _filterStatus;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return authAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        final medicinesAsync = ref.watch(medicinesStreamProvider(user.id));

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.medicines),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => context.push(AppRoutes.addMedicine),
              ),
            ],
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search medicines...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _FilterChip(label: 'All', selected: _filterStatus == null, onTap: () => setState(() => _filterStatus = null)),
                    const SizedBox(width: 8),
                    ...ExpiryStatus.values.map((s) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: s.label,
                        selected: _filterStatus == s.name,
                        color: s.color,
                        onTap: () => setState(() => _filterStatus = _filterStatus == s.name ? null : s.name),
                      ),
                    )),
                  ],
                ),
              ),
              // List
              Expanded(
                child: medicinesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (all) {
                      var medicines = all.where((m) {
                        if (_filterStatus != null && m.status.name != _filterStatus) {
                          return false;
                        }
                        if (_searchQuery.isNotEmpty &&
                            !m.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
                            !m.category.toLowerCase().contains(_searchQuery.toLowerCase())) {
                          return false;
                        }
                        return true;
                      }).toList();

                    if (medicines.isEmpty) {
                      return _buildEmpty(context, all.isEmpty);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      itemCount: medicines.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (ctx, i) => MedicineCard(
                        key: ValueKey(medicines[i].id),
                        medicine: medicines[i],
                      ).animate().fadeIn(delay: (i * 40).ms),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            activeBackgroundColor: AppColors.surfaceLight,
            activeForegroundColor: AppColors.primary,
            visible: true,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            elevation: 8.0,
            shape: const CircleBorder(),
            children: [
              SpeedDialChild(
                child: const Icon(Icons.document_scanner_rounded),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                label: 'AI Prescription Scan',
                onTap: () {
                  final uid = authAsync.valueOrNull?.id;
                  final all = uid != null ? ref.read(medicinesStreamProvider(uid)).valueOrNull : null;
                  final allNames = all?.map((m) => m.name).toList() ?? [];
                  context.push(AppRoutes.prescriptionAnalyzer, extra: allNames);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.medication_rounded),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                label: 'Add Manually',
                onTap: () => context.push(AppRoutes.addMedicine),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context, bool nothingAdded) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_rounded, size: 64, color: AppColors.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            nothingAdded ? 'No medicines yet' : 'No results found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            nothingAdded ? 'Tap + to add your first medicine' : 'Try a different filter or search term',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (nothingAdded) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.addMedicine),
              icon: const Icon(Icons.add),
              label: const Text('Add Medicine'),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? c : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          border: Border.all(color: selected ? c : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : (color ?? AppColors.textSecondary),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
