import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';
import 'radii.dart';
import 'typography.dart';

/// Light + dark [ThemeData] for BongoCal. Both themes register the
/// [AppColorRoles] extension so widgets can read role tokens via
/// `Theme.of(context).extension<AppColorRoles>()`.
@immutable
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    const roles = AppColorRoles.light;
    final colorScheme = ColorScheme.light(
      primary: AppColors.brandEmerald,
      onPrimary: roles.fgOnBrand,
      primaryContainer: AppColors.brandEmerald100,
      onPrimaryContainer: AppColors.brandEmerald700,
      secondary: AppColors.brandRed,
      onSecondary: AppColors.lightFgOnBrand,
      secondaryContainer: AppColors.brandRed100,
      onSecondaryContainer: AppColors.brandRed700,
      tertiary: AppColors.brandGold,
      onTertiary: roles.fgOnGold,
      tertiaryContainer: AppColors.brandGold100,
      onTertiaryContainer: AppColors.brandGold700,
      error: AppColors.error,
      onError: AppColors.lightFgOnBrand,
      errorContainer: AppColors.errorTint,
      onErrorContainer: AppColors.error,
      surface: roles.bgSurface,
      onSurface: roles.fgPrimary,
      surfaceContainerLowest: roles.bgSurface,
      surfaceContainerLow: roles.bgCanvas,
      surfaceContainer: roles.bgSurface2,
      surfaceContainerHigh: roles.bgSurface2,
      surfaceContainerHighest: roles.bgElevated,
      onSurfaceVariant: roles.fgSecondary,
      outline: roles.borderDefault,
      outlineVariant: roles.borderSubtle,
      scrim: roles.bgScrim,
      shadow: const Color(0xFF141413),
    );

    return _buildTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      roles: roles,
      systemUiOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: roles.bgCanvas,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  static ThemeData dark() {
    const roles = AppColorRoles.dark;
    final colorScheme = ColorScheme.dark(
      primary: AppColors.brandEmerald500,
      onPrimary: roles.fgOnBrand,
      primaryContainer: AppColors.darkBrandEmerald100,
      onPrimaryContainer: AppColors.brandEmerald100,
      secondary: AppColors.brandRed,
      onSecondary: AppColors.darkFgOnBrand,
      secondaryContainer: AppColors.darkBrandRed100,
      onSecondaryContainer: AppColors.brandRed100,
      tertiary: AppColors.brandGold,
      onTertiary: roles.fgOnGold,
      tertiaryContainer: AppColors.darkBrandGold100,
      onTertiaryContainer: AppColors.brandGold100,
      error: AppColors.error,
      onError: AppColors.darkFgOnBrand,
      errorContainer: AppColors.darkErrorTint,
      onErrorContainer: AppColors.errorTint,
      surface: roles.bgSurface,
      onSurface: roles.fgPrimary,
      surfaceContainerLowest: roles.bgCanvas,
      surfaceContainerLow: roles.bgSurface,
      surfaceContainer: roles.bgSurface2,
      surfaceContainerHigh: roles.bgSurface2,
      surfaceContainerHighest: roles.bgElevated,
      onSurfaceVariant: roles.fgSecondary,
      outline: roles.borderDefault,
      outlineVariant: roles.borderSubtle,
      scrim: roles.bgScrim,
      shadow: const Color(0xFF000000),
    );

    return _buildTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      roles: roles,
      systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: roles.bgCanvas,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required AppColorRoles roles,
    required SystemUiOverlayStyle systemUiOverlayStyle,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: roles.bgCanvas,
      canvasColor: roles.bgCanvas,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: AppTypography.banglaTextTheme(roles.fgPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: roles.bgCanvas,
        foregroundColor: roles.fgPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        systemOverlayStyle: systemUiOverlayStyle,
        titleTextStyle: AppTypography.h3Bn().copyWith(color: roles.fgPrimary),
      ),
      cardTheme: CardThemeData(
        color: roles.bgSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.mdBorder,
          side: BorderSide(color: roles.borderSubtle),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: roles.borderSubtle,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brandEmerald,
          foregroundColor: roles.fgOnBrand,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.smBorder,
          ),
          textStyle: AppTypography.bodyBn().copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandEmerald,
          textStyle: AppTypography.bodyBn().copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: roles.bgSurface,
        modalBackgroundColor: roles.bgSurface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: AppRadii.lgRadius),
        ),
        modalBarrierColor: roles.bgScrim,
      ),
      extensions: <ThemeExtension<dynamic>>[roles],
    );
  }
}
