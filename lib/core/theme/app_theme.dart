import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── LearnQuest Design Tokens ───────────────────────────────────────────────
// Single source of truth for all colors, typography, and spacing.
// Change here → updates everywhere.

class AppColors {
  AppColors._();

  // Greyish-white gradient palette
  static const gradientStart  = Color(0xFFE8E8EC);
  static const gradientMid    = Color(0xFFE2E2E7);
  static const gradientEnd    = Color(0xFFDCDCE2);

  // Accent colors
  static const blue           = Color(0xFF4A90B8);
  static const blueDark       = Color(0xFF3D7FA3);
  static const green          = Color(0xFF5BA085);
  static const purple         = Color(0xFF7C6FD0);
  static const coral          = Color(0xFFE8593C);

  // Text hierarchy
  static const text1          = Color(0xFF1A2E2A);
  static const text2          = Color(0xFF3D5A52);
  static const text3          = Color(0xFF6B8A82);

  // Glass card — visible on greyish-white bg
  static const glassWhite     = Color(0xFFFFFFFF);   // pure white cards
  static const glassBorder    = Color(0xFFD4D4DA);   // medium grey border

  // Career accent colors
  static const aiAccent       = Color(0xFF4338CA);
  static const aiBg           = Color(0xFFEEF2FF);
  static const webAccent      = Color(0xFF1E40AF);
  static const webBg          = Color(0xFFEFF6FF);
  static const appAccent      = Color(0xFF16A34A);
  static const appBg          = Color(0xFFF0FDF4);
  static const cloudAccent    = Color(0xFF0369A1);
  static const cloudBg        = Color(0xFFF0F9FF);
  static const dsAccent       = Color(0xFF7C3AED);
  static const dsBg           = Color(0xFFF5F3FF);
  static const cyberAccent    = Color(0xFFDC2626);
  static const cyberBg        = Color(0xFFFEF2F2);
}

class AppTextStyles {
  AppTextStyles._();

  // ── Display — Poppins, bold, tight leading ───────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    color: AppColors.text1,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
    height: 1.15,
    letterSpacing: -0.3,
  );

  // ── Headings — Poppins, semibold ─────────────────────────────────────────
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.text1,
    height: 1.3,
  );

  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.text1,
    height: 1.3,
  );

  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.text1,
    height: 1.3,
  );

  // ── Body — Inter, regular/medium ─────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
    height: 1.55,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.text3,
    height: 1.5,
  );

  // ── UI elements ───────────────────────────────────────────────────────────
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: AppColors.text3,
  );

  static TextStyle get chip => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.text2,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.interTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFE8E8EC),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.text1,
      ),
      iconTheme: const IconThemeData(color: AppColors.text1),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.glassBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: GoogleFonts.inter(color: AppColors.text3, fontSize: 14),
    ),
  );
}

