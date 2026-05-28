/// OCR Date Parser — Regex engine to extract expiry dates from raw OCR text
/// Supports: MM/YYYY, DD/MM/YYYY, EXP MM/YY, YYYY-MM-DD, Month-name formats
/// Also supports dual-date scan: simultaneously extracting both MFD and EXP dates.

/// Result of a dual-scan operation (both MFD and EXP detected in one image)
class DualScanResult {
  final ParsedDate? expiryDate;
  final ParsedDate? mfdDate;
  bool get hasExpiry => expiryDate != null;
  bool get hasMfd => mfdDate != null;
  bool get hasBoth => hasExpiry && hasMfd;
  const DualScanResult({this.expiryDate, this.mfdDate});
}

class DateParser {
  DateParser._();

  static const _monthNames = {
    'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
    'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
  };

  // ── Pattern definitions ───────────────────────────────────────────────────

  /// DD/MM/YYYY  e.g. 15/06/2026
  static final _ddMmYYYY = RegExp(r'\b(0?[1-9]|[12]\d|3[01])[\/\-\.](0?[1-9]|1[0-2])[\/\-\.](20\d{2})\b');

  /// YYYY-MM-DD  e.g. 2026-06-15
  static final _yyyyMmDd = RegExp(r'\b(20\d{2})[\/\-](0[1-9]|1[0-2])[\/\-](0[1-9]|[12]\d|3[01])\b');

  /// EXP MM/YY or EXP MM/YYYY  e.g. EXP 06/26, EXP: 06/2026
  static final _expMmYY = RegExp(r'\bEX?P[:\.\s]*(0?[1-9]|1[0-2])[\/\-\.](20?\d{2})\b', caseSensitive: false);

  /// MM/YYYY  e.g. 06/2026
  static final _mmYYYY = RegExp(r'\b(0[1-9]|1[0-2])[\/\-](20\d{2})\b');

  /// MM-YY  e.g. 06-26
  static final _mmYY = RegExp(r'\b(0[1-9]|1[0-2])[\/\-](\d{2})\b');

  /// EXP MonthName YYYY  e.g. EXP AUG 2027, EXP: AUG 2027
  static final _expMonthYYYY = RegExp(
    r'\bEX?P[:\.\s]*([A-Za-z]{3})[\s\.\-]*(20\d{2})\b',
    caseSensitive: false,
  );

  /// MonthName YYYY  e.g. AUG 2027, SEP 2025 (standalone)
  static final _monthYYYY = RegExp(
    r'\b(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)[\s\.\-]*(20\d{2})\b',
    caseSensitive: false,
  );

  /// S.EP.YYYY or similar abbreviated with dots e.g. S.EP.2025
  static final _dotMonthDotYYYY = RegExp(
    r'\b\w?\.(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)\.(20\d{2})\b',
    caseSensitive: false,
  );

  /// YYYY/MM  e.g. 2027/08
  static final _yyyyMm = RegExp(r'\b(20\d{2})[\/\-](0[1-9]|1[0-2])\b');

  // ── Public API ───────────────────────────────────────────────────────────

  /// Main entry point. Returns the most confident parsed result or null.
  static ParsedDate? parse(String rawText) {
    // Normalize text: remove extra spaces, uppercase for matching
    final text = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();
    final results = <_Candidate>[];

    _tryDotMonthDotYYYY(text, results);
    _tryExpMonthYYYY(text, results);
    _tryDdMmYYYY(text, results);
    _tryYYYYMmDd(text, results);
    _tryYYYYMm(text, results);
    _tryExpMmYY(text, results);
    _tryMmYYYY(text, results);
    _tryMonthYYYY(text, results);
    _tryMmYY(text, results);

    if (results.isEmpty) return null;

    // Filter out past dates (likely MFD dates, not EXP dates)
    final now = DateTime.now();
    final futureResults = results.where((r) => r.date.isAfter(now)).toList();
    final validResults = futureResults.isNotEmpty ? futureResults : results;

    // Return highest-confidence result
    validResults.sort((a, b) => b.confidence.compareTo(a.confidence));
    final best = validResults.first;
    return ParsedDate(
      date: best.date,
      confidence: best.confidence,
      patternUsed: best.pattern,
    );
  }

  /// Parses and returns all found dates (for audit log)
  static List<ParsedDate> parseAll(String rawText) {
    final text = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();
    final results = <_Candidate>[];
    _tryDotMonthDotYYYY(text, results);
    _tryExpMonthYYYY(text, results);
    _tryDdMmYYYY(text, results);
    _tryYYYYMmDd(text, results);
    _tryYYYYMm(text, results);
    _tryExpMmYY(text, results);
    _tryMmYYYY(text, results);
    _tryMonthYYYY(text, results);
    _tryMmYY(text, results);
    return results.map((c) => ParsedDate(date: c.date, confidence: c.confidence, patternUsed: c.pattern)).toList();
  }

  /// Dual-date scan: isolates segments labeled MFD/EXP and extracts both.
  /// Falls back to ordering (earlier = MFD, later = EXP) if labels are absent.
  static DualScanResult parseDual(String rawText) {
    final text = rawText.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Try to find explicitly labelled MFD and EXP segments
    final mfdPattern = RegExp(r'MF[DG][:\.\s]*(.{0,30})', caseSensitive: false);
    final expPattern = RegExp(r'EX?P[:\.\s]*(.{0,30})', caseSensitive: false);

    ParsedDate? mfd;
    ParsedDate? exp;

    final mfdMatch = mfdPattern.firstMatch(text);
    if (mfdMatch != null) {
      mfd = parse(mfdMatch.group(1) ?? '');
    }

    final expMatch = expPattern.firstMatch(text);
    if (expMatch != null) {
      exp = parse(expMatch.group(1) ?? '');
    }

    // If only one labelled date found, try to get the other from the full text
    if (exp == null && mfd == null) {
      // No labels: get all dates and assign by chronological order
      final all = parseAll(text);
      all.sort((a, b) => a.date.compareTo(b.date));
      if (all.length >= 2) {
        mfd = all.first;
        exp = all.last;
      } else if (all.length == 1) {
        exp = all.first; // single date is most likely EXP
      }
    } else if (exp == null) {
      // Only MFD found, look for EXP anywhere in full text excluding MFD date
      final allDates = parseAll(text);
      final mfdDate = mfd?.date;
      exp = allDates
          .where((d) => mfdDate == null || d.date != mfdDate)
          .where((d) => d.date.isAfter(DateTime.now()))
          .fold<ParsedDate?>(null, (best, d) =>
              best == null || d.confidence > best.confidence ? d : best);
    } else if (mfd == null) {
      // Only EXP found, look for MFD as any past date
      final allDates = parseAll(text);
      final expDate = exp.date;
      mfd = allDates
          .where((d) => d.date.isBefore(expDate))
          .fold<ParsedDate?>(null, (best, d) =>
              best == null || d.confidence > best.confidence ? d : best);
    }

    return DualScanResult(expiryDate: exp, mfdDate: mfd);
  }

  // ── Pattern handlers ─────────────────────────────────────────────────────

  static void _tryDotMonthDotYYYY(String text, List<_Candidate> out) {
    for (final m in _dotMonthDotYYYY.allMatches(text)) {
      final month = _monthNames[m.group(1)!.toLowerCase()];
      final year = int.tryParse(m.group(2)!);
      if (month == null || year == null) continue;
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.88, pattern: 'X.MON.YYYY'));
    }
  }

  static void _tryExpMonthYYYY(String text, List<_Candidate> out) {
    for (final m in _expMonthYYYY.allMatches(text)) {
      final month = _monthNames[m.group(1)!.toLowerCase()];
      final year = int.tryParse(m.group(2)!);
      if (month == null || year == null) continue;
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.95, pattern: 'EXP MON YYYY'));
    }
  }

  static void _tryMonthYYYY(String text, List<_Candidate> out) {
    for (final m in _monthYYYY.allMatches(text)) {
      final month = _monthNames[m.group(1)!.toLowerCase()];
      final year = int.tryParse(m.group(2)!);
      if (month == null || year == null) continue;
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.78, pattern: 'MON YYYY'));
    }
  }

  static void _tryDdMmYYYY(String text, List<_Candidate> out) {
    for (final m in _ddMmYYYY.allMatches(text)) {
      final day = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final year = int.parse(m.group(3)!);
      final date = _safeDate(year, month, day);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.90, pattern: 'DD/MM/YYYY'));
    }
  }

  static void _tryYYYYMmDd(String text, List<_Candidate> out) {
    for (final m in _yyyyMmDd.allMatches(text)) {
      final year = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final day = int.parse(m.group(3)!);
      final date = _safeDate(year, month, day);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.92, pattern: 'YYYY-MM-DD'));
    }
  }

  static void _tryYYYYMm(String text, List<_Candidate> out) {
    for (final m in _yyyyMm.allMatches(text)) {
      final year = int.parse(m.group(1)!);
      final month = int.parse(m.group(2)!);
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.82, pattern: 'YYYY/MM'));
    }
  }

  static void _tryExpMmYY(String text, List<_Candidate> out) {
    for (final m in _expMmYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final yyStr = m.group(2)!;
      final year = yyStr.length == 4 ? int.parse(yyStr) : 2000 + int.parse(yyStr);
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.85, pattern: 'EXP MM/YY'));
    }
  }

  static void _tryMmYYYY(String text, List<_Candidate> out) {
    for (final m in _mmYYYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final year = int.parse(m.group(2)!);
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.80, pattern: 'MM/YYYY'));
    }
  }

  static void _tryMmYY(String text, List<_Candidate> out) {
    for (final m in _mmYY.allMatches(text)) {
      final month = int.parse(m.group(1)!);
      final yy = int.parse(m.group(2)!);
      if (yy < 24) continue;
      final year = 2000 + yy;
      final date = _safeDate(year, month, 1);
      if (date != null) out.add(_Candidate(date: date, confidence: 0.65, pattern: 'MM/YY'));
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
