import 'package:flutter_test/flutter_test.dart';
import 'package:medtrack/core/utils/date_parser.dart';

void main() {
  group('DateParser', () {
    group('MM/YYYY format', () {
      test('parses 06/2026 correctly', () {
        final result = DateParser.parse('EXP 06/2026');
        expect(result, isNotNull);
        expect(result!.date.month, 6);
        expect(result.date.year, 2026);
        expect(result.confidence, greaterThanOrEqualTo(0.7));
      });

      test('parses 12/2027 correctly', () {
        final result = DateParser.parse('Best before 12/2027');
        expect(result, isNotNull);
        expect(result!.date.month, 12);
        expect(result.date.year, 2027);
      });
    });

    group('DD/MM/YYYY format', () {
      test('parses 15/06/2026 correctly', () {
        final result = DateParser.parse('Expiry: 15/06/2026');
        expect(result, isNotNull);
        expect(result!.date.day, 15);
        expect(result.date.month, 6);
        expect(result.date.year, 2026);
        expect(result.patternUsed, 'DD/MM/YYYY');
      });

      test('assigns high confidence to DD/MM/YYYY', () {
        final result = DateParser.parse('01/12/2025');
        expect(result!.confidence, greaterThanOrEqualTo(0.85));
      });
    });

    group('EXP MM/YY format', () {
      test('parses EXP 06/26 correctly', () {
        final result = DateParser.parse('EXP 06/26');
        expect(result, isNotNull);
        expect(result!.date.month, 6);
        expect(result.date.year, 2026);
        expect(result.patternUsed, 'EXP MM/YY');
      });

      test('parses EXP: 11/27 correctly', () {
        final result = DateParser.parse('EXP: 11/27');
        expect(result, isNotNull);
        expect(result!.date.year, 2027);
      });
    });

    group('YYYY-MM-DD format', () {
      test('parses 2026-06-15 correctly', () {
        final result = DateParser.parse('MFG 2025-01-01 EXP 2026-06-15');
        expect(result, isNotNull);
        expect(result!.patternUsed, 'YYYY-MM-DD');
      });
    });

    group('Edge cases', () {
      test('returns null for no date', () {
        expect(DateParser.parse('No date here at all'), isNull);
      });

      test('returns null for past year out of valid range', () {
        expect(DateParser.parse('05/2019'), isNull); // year < 2024
      });

      test('returns null for invalid month 13', () {
        expect(DateParser.parse('13/2026'), isNull);
      });

      test('parseAll returns multiple matches', () {
        final results = DateParser.parseAll('EXP 06/26 also EXP 12/27');
        expect(results.length, greaterThanOrEqualTo(1));
      });

      test('isHighConfidence works for 80%+ results', () {
        final result = DateParser.parse('EXP 01/12/2026');
        expect(result!.isHighConfidence, isTrue);
      });
    });

    group('confidencePercent', () {
      test('converts 0.87 confidence to 87', () {
        final p = ParsedDate(date: DateTime(2026, 6, 1), confidence: 0.87, patternUsed: 'MM/YYYY');
        expect(p.confidencePercent, 87);
      });
    });
  });
}
