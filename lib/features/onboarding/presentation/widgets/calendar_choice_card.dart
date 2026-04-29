import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Tappable card representing one of the three primary-calendar options
/// on onboarding screen 3. Uses an emerald-tinted surface + 2px border
/// when selected.
class CalendarChoiceCard extends StatelessWidget {
  const CalendarChoiceCard({
    required this.titleBn,
    required this.titleEn,
    required this.exampleDate,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String titleBn;
  final String titleEn;
  final String exampleDate;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isSelected
        ? (isDark ? const Color(0x29006A4E) : AppColors.brandEmerald50)
        : roles.bgSurface;
    final Color border =
        isSelected ? AppColors.brandEmerald : roles.borderSubtle;
    final Color iconFg = isSelected
        ? AppColors.brandEmerald
        : (isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald);

    return Material(
      color: bg,
      borderRadius: AppRadii.lgBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: border,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: AppRadii.lgBorder,
            boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandEmerald
                      .withValues(alpha: isSelected ? 0.18 : 0.10),
                  borderRadius: AppRadii.mdBorder,
                ),
                child: Icon(icon, size: 20, color: iconFg),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: roles.fgPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '$titleEn · e.g. $exampleDate',
                      style: AppTypography.bodySmEn().copyWith(
                        fontSize: 12,
                        color: roles.fgTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  size: 22,
                  color: AppColors.brandEmerald,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
