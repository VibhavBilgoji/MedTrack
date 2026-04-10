import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medtrack/core/constants/app_colors.dart';
import 'package:medtrack/core/constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      primaryContainer: isDark ? AppColors.primaryDark : AppColors.primaryContainer,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      surfaceContainerHighest: isDark ? AppColors.cardDark : AppColors.cardLight,
      onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      onSurfaceVariant: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      outline: isDark ? AppColors.borderDark : AppColors.borderLight,
      error: AppColors.critical,
    );

    final textTheme = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      
      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),

      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // ── OutlinedButton ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // ── TextButton ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // ── InputDecoration ────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDarkElevated : const Color(0xFFF1F5F9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          borderSide: const BorderSide(color: AppColors.critical, width: 1),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
        ),
      ),

      // ── Bottom NavigationBar ───────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        indicatorColor: AppColors.primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return IconThemeData(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            size: 24,
          );
        }),
        elevation: 0,
        height: AppSizes.bottomNavHeight,
      ),

      // ── Chip ──────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.cardDarkElevated : const Color(0xFFF1F5F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        ),
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      ),

      // ── Divider ───────────────────────────────────────────
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
