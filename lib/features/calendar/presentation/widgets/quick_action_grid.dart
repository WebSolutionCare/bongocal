import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Tone variant for the icon chip on a quick-action tile. Mirrors the
/// `.qa-ic.em / .rd / .gd / .gy` palette in the home screen mockup.
enum QuickActionTone { emerald, red, gold, gray }

class QuickAction {
  const QuickAction({
    required this.bnLabel,
    required this.enLabel,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String bnLabel;
  final String enLabel;
  final IconData icon;
  final QuickActionTone tone;
  final VoidCallback onTap;
}

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({required this.actions, super.key})
      : assert(actions.length == 4, 'Quick action grid must have 4 tiles');

  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.7,
      children: <Widget>[
        for (final QuickAction a in actions) _QuickTile(action: a),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.action});

  final QuickAction action;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color iconBg, Color iconFg) = _tonePalette(action.tone, isDark);

    return Material(
      color: roles.bgSurface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: roles.bgSurface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: roles.borderSubtle),
            boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(action.icon, size: 20, color: iconFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      action.bnLabel,
                      style: AppTypography.bodySmBn().copyWith(
                        color: roles.fgPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      action.enLabel,
                      style: AppTypography.bodySmEn().copyWith(
                        color: roles.fgTertiary,
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static (Color, Color) _tonePalette(QuickActionTone tone, bool isDark) {
    switch (tone) {
      case QuickActionTone.emerald:
        return (
          isDark ? AppColors.darkBrandEmerald50 : AppColors.brandEmerald50,
          AppColors.brandEmerald,
        );
      case QuickActionTone.red:
        return (
          isDark ? AppColors.darkBrandRed50 : AppColors.brandRed50,
          isDark ? const Color(0xFFFF8A98) : AppColors.brandRed,
        );
      case QuickActionTone.gold:
        return (
          isDark ? AppColors.darkBrandGold50 : AppColors.brandGold50,
          isDark ? const Color(0xFFE8C969) : AppColors.brandGold700,
        );
      case QuickActionTone.gray:
        return (
          isDark ? AppColors.darkBgSurface2 : AppColors.gray100,
          isDark ? AppColors.darkFgSecondary : AppColors.lightFgSecondary,
        );
    }
  }
}
