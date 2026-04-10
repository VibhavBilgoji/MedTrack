import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack/core/utils/expiry_risk_engine.dart';
import 'package:medtrack/core/constants/app_colors.dart';

void main() {
  group('ExpiryRiskEngine', () {
    group('classify', () {
      test('classifies expired medicine', () {
        final past = DateTime.now().subtract(const Duration(days: 1));
        expect(ExpiryRiskEngine.classify(past), ExpiryStatus.expired);
      });

      test('classifies critical medicine (≤7 days)', () {
        final soon = DateTime.now().add(const Duration(days: 3));
        expect(ExpiryRiskEngine.classify(soon), ExpiryStatus.critical);
      });

      test('classifies expiringSoon medicine (≤30 days)', () {
        final soon = DateTime.now().add(const Duration(days: 20));
        expect(ExpiryRiskEngine.classify(soon), ExpiryStatus.expiringSoon);
      });

      test('classifies safe medicine (>30 days)', () {
        final safe = DateTime.now().add(const Duration(days: 90));
        expect(ExpiryRiskEngine.classify(safe), ExpiryStatus.safe);
      });
    });

    group('computeRiskScore', () {
      test('returns 0 for empty medicine list', () {
        expect(ExpiryRiskEngine.computeRiskScore(total: 0, critical: 0, expiringSoon: 0, expired: 0), 0);
      });

      test('returns low score when all medicines are safe', () {
        final score = ExpiryRiskEngine.computeRiskScore(total: 10, critical: 0, expiringSoon: 0, expired: 0);
        expect(score, 0);
      });

      test('returns high score with many expired', () {
        final score = ExpiryRiskEngine.computeRiskScore(total: 5, critical: 0, expiringSoon: 0, expired: 5);
        expect(score, greaterThan(30));
      });

      test('caps at 100', () {
        final score = ExpiryRiskEngine.computeRiskScore(total: 1, critical: 1, expiringSoon: 1, expired: 1);
        expect(score, lessThanOrEqualTo(100));
      });
    });

    group('riskScoreLabel', () {
      test('Excellent for score 0', () => expect(ExpiryRiskEngine.riskScoreLabel(0), 'Excellent'));
      test('Good for score 20', () => expect(ExpiryRiskEngine.riskScoreLabel(20), 'Good'));
      test('Moderate for score 40', () => expect(ExpiryRiskEngine.riskScoreLabel(40), 'Moderate'));
      test('High Risk for score 60', () => expect(ExpiryRiskEngine.riskScoreLabel(60), 'High Risk'));
      test('Critical for score 80', () => expect(ExpiryRiskEngine.riskScoreLabel(80), 'Critical'));
    });

    group('ExpiryStatus properties', () {
      test('safe has correct label', () => expect(ExpiryStatus.safe.label, 'Safe'));
      test('expired has correct label', () => expect(ExpiryStatus.expired.label, 'Expired'));
      test('critical has correct color', () => expect(ExpiryStatus.critical.color, AppColors.critical));
    });
  });
}
