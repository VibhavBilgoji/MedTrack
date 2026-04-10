/// OCR Date Parser — Regex engine to extract expiry dates from raw OCR text
/// Supports: MM/YYYY, DD/MM/YYYY, EXP MM/YY, YYYY-MM-DD, MFD/EXP labels
class DateParser {
  DateParser._();

  // ── Pattern definitions ───────────────────────────────────────────────────

  /// MM/YYYY  e.g. 06/2026
  static final _mmYYYY = RegExp(r'\b(0[1-9]|1[0-2])[\/\-](20\d{2})\b');

  /// DD/MM/YYYY  e.g. 15/06/2026
  static final _ddMmYYYY = RegExp(r'\b(0[1-9]|[12]\d|3[01])[\/\-](0[1-9]|1[0-2])[\/\-](20\d{2})\b');

  /// EXP MM/YY  e.g. EXP 06/26
  static final _expMmYY = RegExp(r'\bEX?P[:\.\s]*(0[1-9]|1[0-2])[\/\-](\d{2})\b', caseSensitive: false);

  /// YYYY-MM-DD  e.g. 2026-06-15
  static final _yyyyMmDd = RegExp(r'\b(20\d{2})[\/\-](0[1-9]|1[0-2])[\/\-](0[1-9]|[12]\d|3[01])\b');

  /// MM-YY  e.g. 06-26
  static final _mmYY = RegExp(r'\b(0[1-9]|1[0-2])[\/\-](\d{2})\b');

  // ── Public API ───────────────────────────────────────────────────────────

  /// Main entry point. Returns the most confident parsed result or null.
  static ParsedDate? parse(String rawText) {
    final results = <_Candidate>[];

    // Try each pattern, highest confidence first
    _tryDdMmYYYY(rawText, results);
    _tryYYYYMmDd(rawText, results);
    _tryExpMmYY(rawText, results);
    _tryMmYYYY(rawText, results);
    _tryMmYY(rawText, results);

    if (results.isEmpty) return null;

    // Return highest-confidence result
    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    final best = results.first;
    return ParsedDate(
      date: best.date,
      confidence: best.confidence,
      patternUsed: best.pattern,
    );
  }

  /// Parses and returns all found dates (for audit log)
  static List<ParsedDate> parseAll(String rawText) {
    final results = <_Candidate>[];
    _tryDdMmYYYY(rawText, results);
    _tryYYYYMmDd(rawText, results);
    _tryExpMmYY(rawText, results);
    _tryMmYYYY(rawText, results);
    _tryMmYY(rawText, results);
    return results.map((c) => ParsedDate(date: c.date, confidence: c.confidence, patternUsed: c.pattern)).toList();
  }

  // ── Pattern handlers ─────────────────────────────────────────────────────

  static void _tryDdMmYYYY(String text, List<_Candidate> out) {
    for (final m in _ddMmYYYY.allMatches(text)) {
      final day = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final year = int.parse(m.group(3)!);
      final date = _safeDate(year, month, day);
      if (date != null) {
        out.add(_Candidate(date: date, confidence: 0.90, pattern: 'DD/MM/YYYY'));
      }
    }
  }

  static void _tryYYYYMmDd(String text, List<_Candidate> out) {
    for (final m in _yyyyMmDd.allMatches(text)) {
      final year = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final day = int.parse(m.group(3)!);
      final date = _safeDate(year, month, day);
      if (date != null) {
        out.add(_Candidate(date: date, confidence: 0.92, pattern: 'YYYY-MM-DD'));
      }
    }
  }

  static void _tryExpMmYY(String text, List<_Candidate> out) {
    for (final m in _expMmYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final yy = int.parse(m.group(2)!);
      final year = 2000 + yy;
      final date = _safeDate(year, month, 1);
      if (date != null) {
        out.add(_Candidate(date: date, confidence: 0.85, pattern: 'EXP MM/YY'));
      }
    }
  }

  static void _tryMmYYYY(String text, List<_Candidate> out) {
    for (final m in _mmYYYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final year = int.parse(m.group(2)!);
      final date = _safeDate(year, month, 1);
      if (date != null) {
        out.add(_Candidate(date: date, confidence: 0.80, pattern: 'MM/YYYY'));
      }
    }
  }

  static void _tryMmYY(String text, List<_Candidate> out) {
    for (final m in _mmYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final yy = int.parse(m.group(2)!);
      if (yy < 24) return; // Skip clearly invalid years
      final year = 2000 + yy;
      final date = _safeDate(year, month, 1);
      if (date != null) {
        out.add(_Candidate(date: date, confidence: 0.65, pattern: 'MM/YY'));
      }
    }
  }

  static DateTime? _safeDate(int year, int month, int day) {
    try {
      if (year < 2024 || year > 2040) return null;
      if (month < 1 || month > 12) return null;
      if (day < 1 || day > 31) return null;
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }
}

class ParsedDate {
  final DateTime date;
  final double confidence; // 0.0 – 1.0
  final String patternUsed;

  const ParsedDate({
    required this.date,
    required this.confidence,
    required this.patternUsed,
  });

  int get confidencePercent => (confidence * 100).round();
  bool get isHighConfidence => confidence >= 0.80;
}

class _Candidate {
  final DateTime date;
  final double confidence;
  final String pattern;
  _Candidate({required this.date, required this.confidence, required this.pattern});
}
