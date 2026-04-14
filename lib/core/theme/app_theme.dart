import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── LearnQuest Design Tokens ───────────────────────────────────────────────
// Single source of truth for all colors, typography, and spacing.
// Change here → updates everywhere.

class AppColors {
  AppColors._();

  // Pastel gradient palette
  static const gradientStart  = Color(0xFFE8F5EE);
  static const gradientMid    = Color(0xFFD4EADF);
  static const gradientEnd    = Color(0xFFC5DCE8);

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

  // Glass card
  static const glassWhite     = Color(0x8CFFFFFF);   // 55% white
  static const glassBorder    = Color(0xB3FFFFFF);   // 70% white

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

  static TextStyle get displayLarge => GoogleFonts.syne(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.text1,
    height: 1.15,
  );

  static TextStyle get displayMedium => GoogleFonts.syne(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: AppColors.text1,
    height: 1.2,
  );

  static TextStyle get headingLarge => GoogleFonts.syne(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
    height: 1.25,
  );

  static TextStyle get headingMedium => GoogleFonts.syne(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
    height: 1.3,
  );

  static TextStyle get headingSmall => GoogleFonts.syne(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.text1,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
    height: 1.65,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.text2,
    height: 1.6,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.text3,
    height: 1.5,
  );

  static TextStyle get label => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: AppColors.text3,
  );

  static TextStyle get chip => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.text2,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    textTheme: GoogleFonts.dmSansTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.gradientStart,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Syne',
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.text1,
      ),
      iconTheme: IconThemeData(color: AppColors.text1),
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
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0x80FFFFFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xBFFFFFFF), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xBFFFFFFF), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.text3, fontSize: 14),
    ),
  );
}

