import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Flat surface card with hairline border and `xs` shadow at rest. The
/// festival hero card is its own widget — do not embellish [AppCard] with
/// gradients or illustrations.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.s4),
    this.elevated = false,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool elevated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shadows = elevated
        ? (isDark ? AppShadows.smDark : AppShadows.smLight)
        : (isDark ? AppShadows.xsDark : AppShadows.xsLight);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: roles.bgSurface,
        borderRadius: AppRadii.mdBorder,
        border: Border.all(color: roles.borderSubtle),
        boxShadow: shadows,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.mdBorder,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.mdBorder,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
