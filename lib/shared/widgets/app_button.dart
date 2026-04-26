import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Primary, secondary, and ghost button variants matching the design system.
///
/// Press animation: 80 ms, scale 0.97, opacity 0.85, no color change. Hover
/// (when applicable): 120 ms, 4% darker fill or 8% surface tint.
///
/// This is a stub — only the API surface and visual defaults are in place.
/// Full press / hover micro-interactions are added in Phase 1 task DS-01.
enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    final (Color bg, Color fg, BorderSide? border) = switch (variant) {
      AppButtonVariant.primary => (
          AppColors.brandEmerald,
          roles.fgOnBrand,
          null,
        ),
      AppButtonVariant.secondary => (
          roles.bgSurface2,
          roles.fgPrimary,
          BorderSide(color: roles.borderDefault),
        ),
      AppButtonVariant.ghost => (
          Colors.transparent,
          AppColors.brandEmerald,
          null,
        ),
    };

    final child = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: AppSpacing.s2),
        ],
        Text(label),
      ],
    );

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.smBorder,
        side: border ?? BorderSide.none,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadii.smBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s3,
          ),
          child: DefaultTextStyle.merge(
            style: AppTypography.bodyBn().copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
