import 'package:flutter/material.dart';

import '../../../../core/utils/bangla_numerals.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/month_data.dart';

/// 6×7 Sat-first calendar grid. Mirrors `.grid` + `.cell` in the month-view
/// mockup: rounded day number, optional Bangla numeral, holiday/festival/event
/// dots underneath, and Friday cells tinted via a back-layer pill.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    required this.data,
    required this.onSelect,
    this.selectedDate,
    super.key,
  });

  final MonthData data;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _WeekdayHeader(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1 / 1.05,
            children: <Widget>[
              for (final CalendarDayCell cell in data.cells)
                _DayCell(
                  cell: cell,
                  isSelected: selectedDate != null &&
                      cell.date.isSameDay(selectedDate!),
                  onTap: () => onSelect(cell.date.gregorian),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fridayColor =
        isDark ? const Color(0xFFFF8A98) : AppColors.brandRed;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(
                  englishWeekdayShortNames[i].toUpperCase(),
                  style: AppTypography.captionEn().copyWith(
                    color: i == 6 ? fridayColor : roles.fgTertiary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.66,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.cell,
    required this.isSelected,
    required this.onTap,
  });

  final CalendarDayCell cell;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFriday = cell.date.isFriday;
    final bool isToday = cell.isToday;
    final bool isOutside = cell.isOutsideMonth;
    final bool isHoliday = cell.isHoliday;
    final bool isFestival = cell.isFestival;
    final bool hasEvent = cell.hasEvent;

    final Color holidayColor =
        isDark ? const Color(0xFFFF8A98) : AppColors.brandRed;

    final Color numberColor;
    if (isToday) {
      numberColor = Colors.white;
    } else if (isHoliday) {
      numberColor = holidayColor;
    } else if (isOutside) {
      numberColor = roles.fgTertiary.withValues(alpha: 0.5);
    } else {
      numberColor = roles.fgPrimary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: <Widget>[
          // Friday tint sits behind the cell content.
          if (isFriday)
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0x0FF42A41)
                        : AppColors.brandRed50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          // Festival corner badge — small gold disc with glow.
          if (isFestival)
            Positioned(
              top: 4,
              right: 6,
              child: Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.brandGold,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x99D4AF37),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _DayNumber(
                  day: cell.date.gregorian.day,
                  isToday: isToday,
                  isSelected: isSelected,
                  numberColor: numberColor,
                  isOutside: isOutside,
                ),
                const SizedBox(height: 1),
                SizedBox(
                  height: 11,
                  child: Text(
                    BanglaNumerals.fromInt(cell.date.bangla.day),
                    style: AppTypography.bodySmBn().copyWith(
                      color: roles.fgTertiary
                          .withValues(alpha: isOutside ? 0.4 : 1.0),
                      fontSize: 10,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _Dots(
                  isHoliday: isHoliday,
                  isFestival: isFestival,
                  hasEvent: hasEvent,
                  isOutside: isOutside,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayNumber extends StatelessWidget {
  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.numberColor,
    required this.isOutside,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final Color numberColor;
  final bool isOutside;

  @override
  Widget build(BuildContext context) {
    final BoxDecoration decoration;
    if (isToday) {
      decoration = const BoxDecoration(
        color: AppColors.brandEmerald,
        shape: BoxShape.circle,
      );
    } else if (isSelected) {
      decoration = const BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: AppColors.brandEmerald, width: 2),
        ),
      );
    } else {
      decoration = const BoxDecoration(shape: BoxShape.circle);
    }

    return SizedBox(
      width: 36,
      height: 36,
      child: DecoratedBox(
        decoration: decoration,
        child: Center(
          child: Text(
            '$day',
            style: AppTypography.bodyEn().copyWith(
              fontSize: 16,
              fontWeight:
                  isToday || isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected && !isToday
                  ? AppColors.brandEmerald
                  : numberColor,
              letterSpacing: -0.16,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({
    required this.isHoliday,
    required this.isFestival,
    required this.hasEvent,
    required this.isOutside,
    required this.isDark,
  });

  final bool isHoliday;
  final bool isFestival;
  final bool hasEvent;
  final bool isOutside;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final List<Color> dotColors = <Color>[
      if (isHoliday)
        isDark ? const Color(0xFFFF6B7C) : AppColors.brandRed,
      if (isFestival && !isHoliday)
        isDark ? const Color(0xFFE8C969) : AppColors.brandGold,
      if (hasEvent)
        isDark ? const Color(0xFF5FA3DD) : AppColors.info,
    ];
    if (dotColors.isEmpty) {
      return const SizedBox(height: 5);
    }
    return SizedBox(
      height: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < dotColors.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 3),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: dotColors[i]
                    .withValues(alpha: isOutside ? 0.4 : 1.0),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
