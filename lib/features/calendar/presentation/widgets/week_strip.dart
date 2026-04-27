import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/calendar_date.dart';

/// Horizontal week strip — Sat-first row of 7 day chips, today filled in
/// emerald, Friday tinted red. Mirrors `.weekstrip` on the home screen.
class WeekStrip extends StatelessWidget {
  const WeekStrip({
    required this.days,
    required this.todayIndex,
    super.key,
  }) : assert(days.length == 7, 'WeekStrip must have exactly 7 days');

  final List<CalendarDate> days;
  final int todayIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (BuildContext context, int i) {
          return _DayChip(
            date: days[i],
            isToday: i == todayIndex,
          );
        },
      ),
    );
  }
}

class _DayChip extends ConsumerWidget {
  const _DayChip({required this.date, required this.isToday});

  final CalendarDate date;
  final bool isToday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFriday = date.isFriday;

    final Color bg = isToday ? AppColors.brandEmerald : roles.bgSurface;
    final Color border =
        isToday ? AppColors.brandEmerald : roles.borderSubtle;
    final Color dowColor = isToday
        ? Colors.white
        : isFriday
            ? (isDark ? const Color(0xFFFF6B7C) : AppColors.brandRed)
            : roles.fgTertiary;
    final Color numColor = isToday
        ? Colors.white
        : isFriday
            ? (isDark ? const Color(0xFFFF6B7C) : AppColors.brandRed)
            : roles.fgPrimary;
    final Color bnColor = isToday
        ? Colors.white.withValues(alpha: 0.85)
        : roles.fgTertiary;

    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
        boxShadow: isToday
            ? const <BoxShadow>[
                BoxShadow(
                  color: Color(0x4D006A4E),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ]
            : (isDark ? AppShadows.xsDark : AppShadows.xsLight),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            isToday ? 'আজ' : date.banglaWeekdayShort,
            style: AppTypography.bodySmBn().copyWith(
              color: dowColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${date.gregorian.day}',
            style: AppTypography.h3En().copyWith(
              color: numColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.17,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            digits(date.bangla.day),
            style: AppTypography.bodySmBn().copyWith(
              color: bnColor,
              fontSize: 10,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
