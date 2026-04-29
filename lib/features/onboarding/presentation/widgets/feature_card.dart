import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Tone variant for the feature card's icon chip.
enum FeatureCardTone { emerald, gold, red }

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.icon,
    required this.tone,
    required this.titleBn,
    required this.descriptionBn,
    super.key,
  });

  final IconData icon;
  final FeatureCardTone tone;
  final String titleBn;
  final String descriptionBn;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color iconBg, Color iconFg) = _palette(tone, isDark: isDark);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: roles.bgSurface,
        border: Border.all(color: roles.borderSubtle),
        borderRadius: AppRadii.lgBorder,
        boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: AppRadii.mdBorder,
            ),
            child: Icon(icon, size: 22, color: iconFg),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  titleBn,
                  style: AppTypography.h3Bn().copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: roles.fgPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  descriptionBn,
                  style: AppTypography.bodySmBn().copyWith(
                    fontSize: 13,
                    color: roles.fgTertiary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static (Color, Color) _palette(FeatureCardTone tone, {required bool isDark}) {
    switch (tone) {
      case FeatureCardTone.emerald:
        return (
          isDark ? const Color(0x2E006A4E) : AppColors.brandEmerald50,
          isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald,
        );
      case FeatureCardTone.gold:
        return (
          isDark ? const Color(0x29D4AF37) : AppColors.brandGold50,
          isDark ? const Color(0xFFE8C969) : AppColors.brandGold700,
        );
      case FeatureCardTone.red:
        return (
          isDark ? const Color(0x29F42A41) : AppColors.brandRed50,
          isDark ? const Color(0xFFFF8A98) : AppColors.brandRed,
        );
    }
  }
}
