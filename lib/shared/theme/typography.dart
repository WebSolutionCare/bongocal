import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type tokens for BongoCal.
///
/// The app is bilingual; Bangla strings render in Hind Siliguri and Latin
/// strings in Inter. Each scale (`display`, `h1`, … `caption`) provides:
///
/// - [bn] — Hind Siliguri variant for Bangla copy
/// - [en] — Inter variant for Latin copy
///
/// Bangla glyphs sit slightly taller; the line-height multipliers below were
/// tuned for Hind Siliguri but apply to both scripts so mixed-script lines
/// share a single consistent rhythm.
///
/// Letter-spacing in Flutter is absolute logical pixels; we convert the
/// design system's em values once here so callers don't have to.
@immutable
class AppTypography {
  const AppTypography._();

  // ---- Display: 40 / 48 / -1.5% / 700 (use once per screen, max) ----
  static TextStyle displayBn() => GoogleFonts.hindSiliguri(
        fontSize: 40,
        height: 48 / 40,
        letterSpacing: -0.6,
        fontWeight: FontWeight.w700,
      );

  static TextStyle displayEn() => GoogleFonts.inter(
        fontSize: 40,
        height: 48 / 40,
        letterSpacing: -0.6,
        fontWeight: FontWeight.w700,
      );

  // ---- H1: 28 / 34 / -1% / 600 ----
  static TextStyle h1Bn() => GoogleFonts.hindSiliguri(
        fontSize: 28,
        height: 34 / 28,
        letterSpacing: -0.28,
        fontWeight: FontWeight.w600,
      );

  static TextStyle h1En() => GoogleFonts.inter(
        fontSize: 28,
        height: 34 / 28,
        letterSpacing: -0.28,
        fontWeight: FontWeight.w600,
      );

  // ---- H2: 22 / 28 / -0.5% / 600 ----
  static TextStyle h2Bn() => GoogleFonts.hindSiliguri(
        fontSize: 22,
        height: 28 / 22,
        letterSpacing: -0.11,
        fontWeight: FontWeight.w600,
      );

  static TextStyle h2En() => GoogleFonts.inter(
        fontSize: 22,
        height: 28 / 22,
        letterSpacing: -0.11,
        fontWeight: FontWeight.w600,
      );

  // ---- H3: 18 / 24 / -0.25% / 600 ----
  static TextStyle h3Bn() => GoogleFonts.hindSiliguri(
        fontSize: 18,
        height: 24 / 18,
        letterSpacing: -0.045,
        fontWeight: FontWeight.w600,
      );

  static TextStyle h3En() => GoogleFonts.inter(
        fontSize: 18,
        height: 24 / 18,
        letterSpacing: -0.045,
        fontWeight: FontWeight.w600,
      );

  // ---- Body: 16 / 24 / 0 / 400 ----
  static TextStyle bodyBn() => GoogleFonts.hindSiliguri(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle bodyEn() => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
      );

  // ---- Body small: 14 / 20 / 0 / 400 ----
  static TextStyle bodySmBn() => GoogleFonts.hindSiliguri(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle bodySmEn() => GoogleFonts.inter(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
      );

  // ---- Caption: 12 / 16 / +0.5% / 500 (uppercase Latin only — never Bangla) ----
  static TextStyle captionEn() => GoogleFonts.inter(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.06,
        fontWeight: FontWeight.w500,
      );

  /// Material [TextTheme] for Bangla-default surfaces. Most screens use this;
  /// individual Latin-only widgets can override their text style with `*En()`
  /// methods above.
  static TextTheme banglaTextTheme(Color fg) => TextTheme(
        displayLarge: displayBn().copyWith(color: fg),
        headlineLarge: h1Bn().copyWith(color: fg),
        headlineMedium: h2Bn().copyWith(color: fg),
        headlineSmall: h3Bn().copyWith(color: fg),
        titleLarge: h2Bn().copyWith(color: fg),
        titleMedium: h3Bn().copyWith(color: fg),
        bodyLarge: bodyBn().copyWith(color: fg),
        bodyMedium: bodySmBn().copyWith(color: fg),
        labelLarge: bodySmBn().copyWith(color: fg, fontWeight: FontWeight.w600),
        labelSmall: captionEn().copyWith(color: fg),
      );
}
