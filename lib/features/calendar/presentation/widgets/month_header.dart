import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../domain/entities/calendar_date.dart';

/// Top bar of the month view. Mirrors `.topbar` + `.month-switch` from the
/// month-view mockup: prev / next chevrons flanking the month name,
/// secondary BS + Hijri year line, "Today" pill on the trailing edge.
class MonthHeader extends StatelessWidget {
  const MonthHeader({
    required this.year,
    required this.month,
    required this.subtitle,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
    super.key,
  });

  final int year;
  final int month;
  final String subtitle;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final String monthName = englishMonthNames[month - 1];

    return Container(
      decoration: BoxDecoration(
        color: roles.bgCanvas,
        border: Border(bottom: BorderSide(color: roles.borderSubtle)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _ChevronButton(
                  icon: Icons.chevron_left,
                  onTap: onPrevious,
                ),
                const SizedBox(width: 6),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '$monthName $year',
                      style: AppTypography.h3En().copyWith(
                        color: roles.fgPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.18,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmBn().copyWith(
                        color: roles.fgTertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                _ChevronButton(
                  icon: Icons.chevron_right,
                  onTap: onNext,
                ),
              ],
            ),
          ),
          _TodayPill(onTap: onToday, isDark: isDark),
        ],
      ),
    );
  }
}

class _ChevronButton extends StatelessWidget {
  const _ChevronButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 22, color: roles.fgTertiary),
        ),
      ),
    );
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill({required this.onTap, required this.isDark});

  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark
        ? const Color(0x2E006A4E)
        : AppColors.brandEmerald50;
    final Color fg =
        isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald;
    return Material(
      color: bg,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(
            'আজ',
            style: AppTypography.bodySmBn().copyWith(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
