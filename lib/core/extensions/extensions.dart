// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Returns "2 days left", "Expired 3 days ago", etc.
  String get expiryLabel {
    final now = DateTime.now();
    final diff = difference(now).inDays;
    if (diff < 0) return 'Expired ${-diff} day${-diff == 1 ? '' : 's'} ago';
    if (diff == 0) return 'Expires today';
    if (diff == 1) return 'Expires tomorrow';
    return 'Expires in $diff days';
  }

  /// Returns formatted date "12 Apr 2026"
  String get display => DateFormat('d MMM yyyy').format(this);

  /// Returns short "Apr 2026"
  String get displayShort => DateFormat('MMM yyyy').format(this);

  /// Returns "2026-04" for grouping
  String get monthKey => DateFormat('yyyy-MM').format(this);

  /// Returns number of days until expiry (negative = expired)
  int get daysUntilExpiry => difference(DateTime.now()).inDays;

  /// Returns true if within the next [days] days
  bool isExpiringWithin(int days) {
    final diff = daysUntilExpiry;
    return diff >= 0 && diff <= days;
  }

  bool get isExpired => isBefore(DateTime.now());
}

extension StringExtensions on String {
  /// Capitalizes first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Returns true if valid email format
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  /// Returns true if password meets minimum requirements
  bool get isStrongPassword => length >= 8;

  /// Trims and checks if blank
  bool get isBlank => trim().isEmpty;
}
