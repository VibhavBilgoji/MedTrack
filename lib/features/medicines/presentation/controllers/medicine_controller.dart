import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/medicine_entity.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/expiry_risk_engine.dart';

// ── Medicine list stream provider per user ────────────────────────────────────
final medicinesStreamProvider = StreamProvider.family<List<MedicineEntity>, String>((ref, userId) {
  return ref.watch(watchMedicinesUseCaseProvider)(userId);
});

// ── Dashboard stats derived from medicines list ────────────────────────────────
class DashboardStats {
  final int total;
  final int safe;
  final int expiringSoon;
  final int critical;
  final int expired;
  final int riskScore;
  final Map<String, int> byCategory;
  final Map<String, int> monthlyExpiry; // key: "yyyy-MM"

  const DashboardStats({
    required this.total,
    required this.safe,
    required this.expiringSoon,
    required this.critical,
    required this.expired,
    required this.riskScore,
    required this.byCategory,
    required this.monthlyExpiry,
  });

  factory DashboardStats.empty() => const DashboardStats(
    total: 0, safe: 0, expiringSoon: 0, critical: 0, expired: 0,
    riskScore: 0, byCategory: {}, monthlyExpiry: {},
  );

  factory DashboardStats.fromMedicines(List<MedicineEntity> medicines) {
    int safe = 0, expiringSoon = 0, critical = 0, expired = 0;
    final byCategory = <String, int>{};
    final monthlyExpiry = <String, int>{};

    for (final m in medicines) {
      switch (m.status) {
        case ExpiryStatus.safe: safe++; break;
        case ExpiryStatus.expiringSoon: expiringSoon++; break;
        case ExpiryStatus.critical: critical++; break;
        case ExpiryStatus.expired: expired++; break;
      }
      byCategory[m.category] = (byCategory[m.category] ?? 0) + 1;
      final key = '${m.expiryDate.year}-${m.expiryDate.month.toString().padLeft(2, '0')}';
      monthlyExpiry[key] = (monthlyExpiry[key] ?? 0) + 1;
    }

    return DashboardStats(
      total: medicines.length,
      safe: safe,
      expiringSoon: expiringSoon,
      critical: critical,
      expired: expired,
      riskScore: ExpiryRiskEngine.computeRiskScore(
        total: medicines.length,
        critical: critical,
        expiringSoon: expiringSoon,
        expired: expired,
      ),
      byCategory: byCategory,
      monthlyExpiry: monthlyExpiry,
    );
  }
}

final dashboardStatsProvider = Provider.family<DashboardStats, String>((ref, userId) {
  final asyncMedicines = ref.watch(medicinesStreamProvider(userId));
  return asyncMedicines.when(
    data: (medicines) => DashboardStats.fromMedicines(medicines),
    loading: () => DashboardStats.empty(),
    error: (_, __) => DashboardStats.empty(),
  );
});

// ── Add/Edit Medicine Controller ───────────────────────────────────────────────
class MedicineFormState {
  final bool isLoading;
  final String? error;
  final bool success;
  const MedicineFormState({this.isLoading = false, this.error, this.success = false});
}

class MedicineFormController extends StateNotifier<MedicineFormState> {
  final Ref _ref;
  MedicineFormController(this._ref) : super(const MedicineFormState());

  Future<bool> addMedicine(MedicineEntity medicine) async {
    state = const MedicineFormState(isLoading: true);
    final result = await _ref.read(addMedicineUseCaseProvider)(medicine);
    return result.fold(
      (failure) {
        state = MedicineFormState(error: failure.message);
        return false;
      },
      (_) {
        state = const MedicineFormState(success: true);
        return true;
      },
    );
  }

  Future<bool> updateMedicine(MedicineEntity medicine) async {
    state = const MedicineFormState(isLoading: true);
    final result = await _ref.read(updateMedicineUseCaseProvider)(medicine);
    return result.fold(
      (failure) {
        state = MedicineFormState(error: failure.message);
        return false;
      },
      (_) {
        state = const MedicineFormState(success: true);
        return true;
      },
    );
  }

  Future<bool> deleteMedicine(String userId, String id) async {
    state = const MedicineFormState(isLoading: true);
    final result = await _ref.read(deleteMedicineUseCaseProvider)(userId, id);
    return result.fold(
      (failure) {
        state = MedicineFormState(error: failure.message);
        return false;
      },
      (_) {
        state = const MedicineFormState(success: true);
        return true;
      },
    );
  }
}

final medicineFormControllerProvider = StateNotifierProvider<MedicineFormController, MedicineFormState>((ref) {
  return MedicineFormController(ref);
});
