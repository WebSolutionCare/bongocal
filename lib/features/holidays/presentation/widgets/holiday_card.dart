import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../calendar/domain/entities/calendar_date.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';

/// Single-row holiday card used on the holidays list. Mirrors `.h-card`
/// in design_system/BongoCal Holidays List.html — a 4 px type-colored
/// accent on the left edge, a Latin date badge, the holiday name in
/// Bangla + English, type pill, and the relative-date label.
class HolidayCard extends StatelessWidget {
  const HolidayCard({
    required this.holiday,
    required this.daysFromToday,
    required this.banglaDayLabel,
    required this.onTap,
    super.key,
  });

  final Holiday holiday;
  final int daysFromToday;
  final String banglaDayLabel; // e.g. `১২ চৈত্র`
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _CardPalette palette = _CardPalette.of(holiday.type, isDark: isDark);

    return Material(
      color: roles.bgSurface,
      borderRadius: AppRadii.lgBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: roles.bgSurface,
            border: Border.all(color: roles.borderSubtle),
            borderRadius: AppRadii.lgBorder,
            boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
          ),
          child: ClipRRect(
            borderRadius: AppRadii.lgBorder,
            child: Stack(
              children: <Widget>[
                // 4 px type-colored accent stripe on the left edge.
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(width: 4, color: palette.accent),
                ),
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 14, 14, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _DateBadge(
                        date: holiday.date,
                        accent: palette.accent,
                        banglaDayLabel: banglaDayLabel,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                holiday.nameBn,
                                style: AppTypography.h3Bn().copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: roles.fgPrimary,
                                  height: 1.25,
                                  letterSpacing: -0.08,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                holiday.nameEn,
                                style: AppTypography.bodySmEn().copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: roles.fgTertiary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  _TypePill(
                                    label: holiday.type.displayNameBn,
                                    bg: palette.pillBg,
                                    fg: palette.pillFg,
                                  ),
                                  Text(
                                    _englishWeekday(holiday.date),
                                    style:
                                        AppTypography.bodySmEn().copyWith(
                                      fontSize: 11,
                                      color: roles.fgTertiary,
                                    ),
                                  ),
                                  _RelativeDate(
                                    days: daysFromToday,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _englishWeekday(DateTime date) {
    // CalendarDate.satFirstIndex covers Sat-first; for the card label we
    // want the natural English weekday name.
    const List<String> names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[date.weekday - 1];
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({
    required this.date,
    required this.accent,
    required this.banglaDayLabel,
  });

  final DateTime date;
  final Color accent;
  final String banglaDayLabel;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SizedBox(
      width: 56,
      child: Column(
        children: <Widget>[
          Text(
            englishMonthShortNames[date.month - 1].toUpperCase(),
            style: AppTypography.captionEn().copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: accent,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${date.day}',
            style: AppTypography.h2En().copyWith(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1,
              color: roles.fgPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            banglaDayLabel,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 10,
              color: roles.fgTertiary,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.pillBorder),
      child: Text(
        label,
        style: AppTypography.bodySmBn().copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
          height: 1.2,
        ),
      ),
    );
  }
}

class _RelativeDate extends ConsumerWidget {
  const _RelativeDate({required this.days});

  final int days;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isFuture = days > 0;
    final bool isToday = days == 0;

    final String label;
    if (isToday) {
      label = 'আজ';
    } else if (isFuture) {
      label = '${digits(days)} দিন পরে';
    } else {
      label = '${digits(days.abs())} দিন আগে';
    }

    final Color color = isFuture || isToday
        ? (isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald)
        : roles.fgTertiary;

    return Text(
      label,
      style: AppTypography.bodySmBn().copyWith(
        fontSize: 11,
        color: color,
        fontWeight: isFuture || isToday ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

@immutable
class _CardPalette {
  const _CardPalette({
    required this.accent,
    required this.pillBg,
    required this.pillFg,
  });

  factory _CardPalette.of(HolidayType type, {required bool isDark}) {
    switch (type) {
      case HolidayType.religious:
        return _CardPalette(
          accent: AppColors.brandGold,
          pillBg: isDark
              ? const Color(0x2ED4AF37)
              : AppColors.brandGold50,
          pillFg: isDark
              ? const Color(0xFFE8C969)
              : AppColors.brandGold700,
        );
      case HolidayType.governmentNational:
        return _CardPalette(
          accent: AppColors.brandRed,
          pillBg: isDark
              ? const Color(0x2EF42A41)
              : AppColors.brandRed50,
          pillFg: isDark
              ? const Color(0xFFFF8A98)
              : AppColors.brandRed700,
        );
      case HolidayType.international:
        return _CardPalette(
          accent: AppColors.brandEmerald,
          pillBg: isDark
              ? const Color(0x38006A4E)
              : AppColors.brandEmerald50,
          pillFg: isDark
              ? const Color(0xFF4FB394)
              : AppColors.brandEmerald,
        );
      case HolidayType.optional:
        return _CardPalette(
          accent: AppColors.gray400,
          pillBg: isDark ? AppColors.darkBgSurface2 : AppColors.gray100,
          pillFg: isDark ? AppColors.darkFgSecondary : AppColors.lightFgSecondary,
        );
      case HolidayType.observance:
        return _CardPalette(
          accent: AppColors.gray400,
          pillBg: isDark ? AppColors.darkBgSurface2 : AppColors.gray100,
          pillFg: isDark ? AppColors.darkFgSecondary : AppColors.lightFgSecondary,
        );
    }
  }

  final Color accent;
  final Color pillBg;
  final Color pillFg;
}
