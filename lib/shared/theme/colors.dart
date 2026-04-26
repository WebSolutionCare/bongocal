import 'package:flutter/material.dart';

/// BongoCal color tokens.
///
/// Mirrors [design_system/colors_and_type.css]. Do not introduce hex literals
/// elsewhere — always reference these tokens or the role getters on
/// [AppColorRoles].
@immutable
class AppColors {
  const AppColors._();

  // Brand — emerald (Bangladesh flag green)
  static const Color brandEmerald = Color(0xFF006A4E);
  static const Color brandEmerald700 = Color(0xFF005A42);
  static const Color brandEmerald600 = Color(0xFF007558);
  static const Color brandEmerald500 = Color(0xFF008A66);
  static const Color brandEmerald100 = Color(0xFFD6EDE5);
  static const Color brandEmerald50 = Color(0xFFEAF6F1);

  // Brand — warm flag red
  static const Color brandRed = Color(0xFFF42A41);
  static const Color brandRed700 = Color(0xFFC71F33);
  static const Color brandRed100 = Color(0xFFFDE0E4);
  static const Color brandRed50 = Color(0xFFFEF0F2);

  // Brand — gold (premium / festival)
  static const Color brandGold = Color(0xFFD4AF37);
  static const Color brandGold700 = Color(0xFFA8881C);
  static const Color brandGold100 = Color(0xFFF5EBC4);
  static const Color brandGold50 = Color(0xFFFBF6E1);

  // Convenience aliases used in CLAUDE.md
  static const Color primary = brandEmerald;
  static const Color accentRed = brandRed;
  static const Color gold = brandGold;

  // Hero gradient stops (today card + festival hero). Pulled from
  // design_system/BongoCal Home Screen.html — used only on these surfaces.
  static const Color brandEmeraldHeroLight1 = Color(0xFF00785A);
  static const Color brandEmeraldHeroLight3 = Color(0xFF004A36);
  static const Color brandEmeraldHeroDark2 = Color(0xFF004B36);
  static const Color brandEmeraldHeroDark3 = Color(0xFF002A1F);

  // Neutrals (warm-leaning)
  static const Color gray50 = Color(0xFFFAFAF8);
  static const Color gray100 = Color(0xFFF4F4F1);
  static const Color gray200 = Color(0xFFE8E8E3);
  static const Color gray300 = Color(0xFFD4D4CC);
  static const Color gray400 = Color(0xFFA8A89E);
  static const Color gray500 = Color(0xFF767670);
  static const Color gray600 = Color(0xFF535350);
  static const Color gray700 = Color(0xFF3A3A38);
  static const Color gray800 = Color(0xFF232322);
  static const Color gray900 = Color(0xFF141413);

  // Semantic (status)
  static const Color success = Color(0xFF1F8A4C);
  static const Color successTint = Color(0xFFDBEFE2);
  static const Color warning = Color(0xFFC97A11);
  static const Color warningTint = Color(0xFFFAEBCD);
  static const Color error = Color(0xFFD02D2D);
  static const Color errorTint = Color(0xFFF9DCDC);
  static const Color info = Color(0xFF1E6FBE);
  static const Color infoTint = Color(0xFFDDEAF8);

  // Festival accents
  static const Color festivalEid = Color(0xFFD4AF37);
  static const Color festivalBoishakh = Color(0xFFE63946);
  static const Color festivalIndependence = Color(0xFF006A4E);
  static const Color festivalVictory = Color(0xFFB5172A);
  static const Color festivalPuja = Color(0xFFE07A1F);

  // === Light theme roles ===
  static const Color lightBgCanvas = Color(0xFFFAFAF8);
  static const Color lightBgSurface = Color(0xFFFFFFFF);
  static const Color lightBgSurface2 = Color(0xFFF4F4F1);
  static const Color lightBgElevated = Color(0xFFFFFFFF);
  static const Color lightBgScrim = Color(0x73141413); // rgba(20,20,19, 0.45)

  static const Color lightFgPrimary = Color(0xFF141413);
  static const Color lightFgSecondary = Color(0xFF535350);
  static const Color lightFgTertiary = Color(0xFF767670);
  static const Color lightFgOnBrand = Color(0xFFFFFFFF);
  static const Color lightFgOnGold = Color(0xFF1A1A18);

  static const Color lightBorderSubtle = Color(0x14141413); // 0.08
  static const Color lightBorderDefault = Color(0x24141413); // 0.14
  static const Color lightBorderStrong = Color(0x38141413); // 0.22

  // === Dark theme roles ===
  static const Color darkBgCanvas = Color(0xFF0E0E0D);
  static const Color darkBgSurface = Color(0xFF1A1A18);
  static const Color darkBgSurface2 = Color(0xFF232322);
  static const Color darkBgElevated = Color(0xFF2A2A28);
  static const Color darkBgScrim = Color(0x99000000); // rgba(0,0,0, 0.6)

  static const Color darkFgPrimary = Color(0xFFF4F4F1);
  static const Color darkFgSecondary = Color(0xFFB8B8B0);
  static const Color darkFgTertiary = Color(0xFF8A8A82);
  static const Color darkFgOnBrand = Color(0xFFFFFFFF);
  static const Color darkFgOnGold = Color(0xFF1A1A18);

  static const Color darkBorderSubtle = Color(0x14FFFFFF); // 0.08
  static const Color darkBorderDefault = Color(0x24FFFFFF); // 0.14
  static const Color darkBorderStrong = Color(0x38FFFFFF); // 0.22

  static const Color darkBrandEmerald100 = Color(0xFF133D31);
  static const Color darkBrandEmerald50 = Color(0xFF0F2B23);
  static const Color darkBrandRed100 = Color(0xFF3D1117);
  static const Color darkBrandRed50 = Color(0xFF2A0C10);
  static const Color darkBrandGold100 = Color(0xFF3D3318);
  static const Color darkBrandGold50 = Color(0xFF2A240F);

  static const Color darkSuccessTint = Color(0xFF143D24);
  static const Color darkWarningTint = Color(0xFF3D2A0E);
  static const Color darkErrorTint = Color(0xFF3D1414);
  static const Color darkInfoTint = Color(0xFF142A3D);
}

/// Theme-aware role tokens. Use these in widgets via `Theme.of(context)`-driven
/// extensions rather than touching [AppColors.lightX] / [AppColors.darkX]
/// directly.
@immutable
class AppColorRoles extends ThemeExtension<AppColorRoles> {
  const AppColorRoles({
    required this.bgCanvas,
    required this.bgSurface,
    required this.bgSurface2,
    required this.bgElevated,
    required this.bgScrim,
    required this.fgPrimary,
    required this.fgSecondary,
    required this.fgTertiary,
    required this.fgOnBrand,
    required this.fgOnGold,
    required this.borderSubtle,
    required this.borderDefault,
    required this.borderStrong,
  });

  static const AppColorRoles light = AppColorRoles(
    bgCanvas: AppColors.lightBgCanvas,
    bgSurface: AppColors.lightBgSurface,
    bgSurface2: AppColors.lightBgSurface2,
    bgElevated: AppColors.lightBgElevated,
    bgScrim: AppColors.lightBgScrim,
    fgPrimary: AppColors.lightFgPrimary,
    fgSecondary: AppColors.lightFgSecondary,
    fgTertiary: AppColors.lightFgTertiary,
    fgOnBrand: AppColors.lightFgOnBrand,
    fgOnGold: AppColors.lightFgOnGold,
    borderSubtle: AppColors.lightBorderSubtle,
    borderDefault: AppColors.lightBorderDefault,
    borderStrong: AppColors.lightBorderStrong,
  );

  static const AppColorRoles dark = AppColorRoles(
    bgCanvas: AppColors.darkBgCanvas,
    bgSurface: AppColors.darkBgSurface,
    bgSurface2: AppColors.darkBgSurface2,
    bgElevated: AppColors.darkBgElevated,
    bgScrim: AppColors.darkBgScrim,
    fgPrimary: AppColors.darkFgPrimary,
    fgSecondary: AppColors.darkFgSecondary,
    fgTertiary: AppColors.darkFgTertiary,
    fgOnBrand: AppColors.darkFgOnBrand,
    fgOnGold: AppColors.darkFgOnGold,
    borderSubtle: AppColors.darkBorderSubtle,
    borderDefault: AppColors.darkBorderDefault,
    borderStrong: AppColors.darkBorderStrong,
  );

  final Color bgCanvas;
  final Color bgSurface;
  final Color bgSurface2;
  final Color bgElevated;
  final Color bgScrim;

  final Color fgPrimary;
  final Color fgSecondary;
  final Color fgTertiary;
  final Color fgOnBrand;
  final Color fgOnGold;

  final Color borderSubtle;
  final Color borderDefault;
  final Color borderStrong;

  @override
  AppColorRoles copyWith({
    Color? bgCanvas,
    Color? bgSurface,
    Color? bgSurface2,
    Color? bgElevated,
    Color? bgScrim,
    Color? fgPrimary,
    Color? fgSecondary,
    Color? fgTertiary,
    Color? fgOnBrand,
    Color? fgOnGold,
    Color? borderSubtle,
    Color? borderDefault,
    Color? borderStrong,
  }) =>
      AppColorRoles(
        bgCanvas: bgCanvas ?? this.bgCanvas,
        bgSurface: bgSurface ?? this.bgSurface,
        bgSurface2: bgSurface2 ?? this.bgSurface2,
        bgElevated: bgElevated ?? this.bgElevated,
        bgScrim: bgScrim ?? this.bgScrim,
        fgPrimary: fgPrimary ?? this.fgPrimary,
        fgSecondary: fgSecondary ?? this.fgSecondary,
        fgTertiary: fgTertiary ?? this.fgTertiary,
        fgOnBrand: fgOnBrand ?? this.fgOnBrand,
        fgOnGold: fgOnGold ?? this.fgOnGold,
        borderSubtle: borderSubtle ?? this.borderSubtle,
        borderDefault: borderDefault ?? this.borderDefault,
        borderStrong: borderStrong ?? this.borderStrong,
      );

  @override
  AppColorRoles lerp(ThemeExtension<AppColorRoles>? other, double t) {
    if (other is! AppColorRoles) return this;
    return AppColorRoles(
      bgCanvas: Color.lerp(bgCanvas, other.bgCanvas, t)!,
      bgSurface: Color.lerp(bgSurface, other.bgSurface, t)!,
      bgSurface2: Color.lerp(bgSurface2, other.bgSurface2, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgScrim: Color.lerp(bgScrim, other.bgScrim, t)!,
      fgPrimary: Color.lerp(fgPrimary, other.fgPrimary, t)!,
      fgSecondary: Color.lerp(fgSecondary, other.fgSecondary, t)!,
      fgTertiary: Color.lerp(fgTertiary, other.fgTertiary, t)!,
      fgOnBrand: Color.lerp(fgOnBrand, other.fgOnBrand, t)!,
      fgOnGold: Color.lerp(fgOnGold, other.fgOnGold, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
    );
  }
}
