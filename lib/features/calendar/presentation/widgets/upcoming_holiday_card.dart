import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../domain/entities/calendar_date.dart';

/// Holiday-with-countdown card that sits below the today hero. Mirrors the
/// `.holiday` block in BongoCal Home Screen.html — circular ring with the
/// day number inside, holiday name + government pill + Gregorian date.
class UpcomingHolidayCard extends ConsumerWidget {
  const UpcomingHolidayCard({
    required this.holiday,
    required this.daysAway,
    this.onTap,
    super.key,
  });

  final Holiday holiday;
  final int daysAway;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? const Color(0xFFFF6B7C) : AppColors.brandRed;

    return Material(
      color: roles.bgSurface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: roles.bgSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: roles.borderSubtle),
            boxShadow: isDark ? AppShadows.smDark : AppShadows.smLight,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -40,
                top: -40,
                child: IgnorePointer(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          Color(0x1AD4AF37),
                          Color(0x00D4AF37),
                        ],
                        stops: <double>[0.0, 0.7],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Row(
                  children: <Widget>[
                    _CountdownRing(
                      daysAway: daysAway,
                      accent: accent,
                      digits: digits,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${digits(daysAway)} দিন বাকি',
                            style: AppTypography.bodySmBn().copyWith(
                              color: roles.fgTertiary,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.06,
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: AppTypography.h3Bn().copyWith(
                                color: roles.fgPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              children: <InlineSpan>[
                                TextSpan(text: holiday.nameBn),
                                TextSpan(
                                  text: '  ${holiday.nameEn}',
                                  style: AppTypography.bodySmEn().copyWith(
                                    color: roles.fgTertiary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              if (holiday.isGovernmentHoliday)
                                _Pill(
                                  label: 'সরকারি ছুটি',
                                  bg: isDark
                                      ? const Color(0x26F42A41)
                                      : AppColors.brandRed50,
                                  fg: isDark
                                      ? const Color(0xFFFF8A98)
                                      : AppColors.brandRed700,
                                ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  _englishDate(holiday.date),
                                  style: AppTypography.bodySmEn().copyWith(
                                    color: roles.fgTertiary,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: roles.fgTertiary,
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

  static String _englishDate(DateTime d) {
    final String weekday = englishWeekdayShortNames[(d.weekday + 1) % 7];
    final String month = englishMonthShortNames[d.month - 1];
    return '$weekday, ${d.day} $month';
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    required this.daysAway,
    required this.accent,
    required this.digits,
  });

  final int daysAway;
  final Color accent;
  final String Function(int) digits;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(roles.bgSurface2),
            ),
          ),
          SizedBox(
            width: 56,
            height: 56,
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: CircularProgressIndicator(
                value: _fillRatio(daysAway),
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          Text(
            digits(daysAway),
            style: AppTypography.h3Bn().copyWith(
              color: accent,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  static double _fillRatio(int daysAway) {
    if (daysAway <= 0) return 1.0;
    if (daysAway >= 30) return 0.1;
    return 1.0 - daysAway / 30.0;
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.pillBorder),
      child: Text(
        label,
        style: AppTypography.bodySmBn().copyWith(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
