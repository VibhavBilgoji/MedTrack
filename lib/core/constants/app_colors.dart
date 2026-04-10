import 'package:flutter/material.dart';

/// MedTrack color palette — medical blue with semantic status colors
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────
  static const Color primary = Color(0xFF1A6EFF);
  static const Color primaryLight = Color(0xFF4D8FFF);
  static const Color primaryDark = Color(0xFF0047CC);
  static const Color primaryContainer = Color(0xFFDCEAFF);

  // ── Status (Expiry Risk) ───────────────────────────────────
  static const Color safe = Color(0xFF22C55E);
  static const Color safeContainer = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color critical = Color(0xFFEF4444);
  static const Color criticalContainer = Color(0xFFFEE2E2);
  static const Color expired = Color(0xFF6B7280);
  static const Color expiredContainer = Color(0xFFF3F4F6);

  // ── Surface (Light) ───────────────────────────────────────
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);

  // ── Surface (Dark) ────────────────────────────────────────
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color cardDarkElevated = Color(0xFF283548);
  static const Color borderDark = Color(0xFF334155);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ── Chart Colors ──────────────────────────────────────────
  static const List<Color> chartColors = [
    Color(0xFF1A6EFF),
    Color(0xFF22C55E),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFFEC4899),
  ];

  // ── Glassmorphism ─────────────────────────────────────────
  static Color glassDark = const Color(0xFF1E293B).withValues(alpha: 0.6);
  static Color glassLight = Colors.white.withValues(alpha: 0.7);
  static Color glassBorderDark = Colors.white.withValues(alpha: 0.1);
  static Color glassBorderLight = const Color(0xFF1A6EFF).withValues(alpha: 0.15);
}
