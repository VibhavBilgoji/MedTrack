import '../constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Expiry risk levels for visual classification
enum ExpiryStatus {
  safe,
  expiringSoon,
  critical,
  expired;

  String get label {
    switch (this) {
      case ExpiryStatus.safe: return 'Safe';
      case ExpiryStatus.expiringSoon: return 'Expiring Soon';
      case ExpiryStatus.critical: return 'Critical';
      case ExpiryStatus.expired: return 'Expired';
    }
  }

  Color get color {
    switch (this) {
      case ExpiryStatus.safe: return AppColors.safe;
      case ExpiryStatus.expiringSoon: return AppColors.warning;
      case ExpiryStatus.critical: return AppColors.critical;
      case ExpiryStatus.expired: return AppColors.expired;
    }
  }

  Color get containerColor {
    switch (this) {
      case ExpiryStatus.safe: return AppColors.safeContainer;
      case ExpiryStatus.expiringSoon: return AppColors.warningContainer;
      case ExpiryStatus.critical: return AppColors.criticalContainer;
      case ExpiryStatus.expired: return AppColors.expiredContainer;
    }
  }

  IconData get icon {
    switch (this) {
      case ExpiryStatus.safe: return Icons.check_circle_rounded;
      case ExpiryStatus.expiringSoon: return Icons.access_time_rounded;
      case ExpiryStatus.critical: return Icons.warning_rounded;
      case ExpiryStatus.expired: return Icons.cancel_rounded;
    }
  }
}

/// Core engine for computing expiry risk status and score
class ExpiryRiskEngine {
  ExpiryRiskEngine._();

  /// Classify a medicine by its expiry date
  static ExpiryStatus classify(DateTime expiryDate) {
    final daysLeft = expiryDate.difference(DateTime.now()).inDays;
    if (daysLeft < 0) return ExpiryStatus.expired;
    if (daysLeft <= 7) return ExpiryStatus.critical;
    if (daysLeft <= 30) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.safe;
  }

  /// Compute household risk score (0–100). Higher = more urgent.
  /// Score sums weighted risk across all medicines.
  static int computeRiskScore({
    required int total,
    required int critical,
    required int expiringSoon,
    required int expired,
  }) {
    if (total == 0) return 0;
    final rawScore = (expired * 40 + critical * 25 + expiringSoon * 10) / total;
    return (rawScore).clamp(0, 100).round();
  }

  /// Returns a friendly human label for the risk score
  static String riskScoreLabel(int score) {
    if (score <= 10) return 'Excellent';
    if (score <= 30) return 'Good';
    if (score <= 50) return 'Moderate';
    if (score <= 70) return 'High Risk';
    return 'Critical';
  }

  static Color riskScoreColor(int score) {
    if (score <= 10) return AppColors.safe;
    if (score <= 30) return AppColors.safe;
    if (score <= 50) return AppColors.warning;
    if (score <= 70) return AppColors.critical;
    return AppColors.critical;
  }
}
