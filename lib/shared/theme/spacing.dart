import 'package:flutter/widgets.dart';

/// 4px base spacing scale per design system.
///
/// Use `AppSpacing.s4` (16px) for card padding, `AppSpacing.gutter` (20px)
/// for screen edge gutter.
@immutable
class AppSpacing {
  const AppSpacing._();

  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s12 = 48;
  static const double s16 = 64;

  /// Screen edge gutter (20px) — see design_system/README.md "Layout rules".
  static const double gutter = 20;

  /// Top app bar height (56px).
  static const double appBarHeight = 56;

  /// Bottom nav height (excluding safe area, 64px).
  static const double bottomNavHeight = 64;

  /// Floating action button diameter (56px).
  static const double fabSize = 56;

  /// Minimum touch target (44–48px range; we use 48 as the default).
  static const double touchTarget = 48;
}
