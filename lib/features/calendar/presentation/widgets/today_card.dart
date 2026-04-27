import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/calendar_date.dart';

/// The "Today" hero card — emerald gradient surface that displays the
/// Gregorian, Bengali, and Hijri view of today.
///
/// Mirrors the `.hero` block in design_system/BongoCal Home Screen.html.
class TodayCard extends ConsumerWidget {
  const TodayCard({required this.today, super.key});

  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool useBn = ref.watch(useBanglaNumeralsProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: _heroGradient(isDark: isDark),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x2E00503C),
            offset: Offset(0, 6),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Color(0x4700503C),
            offset: Offset(0, 18),
            blurRadius: 40,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          // Faint paisley arc — barely there ring set in the top-right.
          Positioned(
            right: -90,
            top: -90,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.04),
                      blurRadius: 0,
                      spreadRadius: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _Eyebrow(weekdayEn: today.englishWeekday),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${today.gregorian.day}',
                    style: AppTypography.displayEn().copyWith(
                      fontSize: 96,
                      height: 0.95,
                      letterSpacing: -4.3,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        today.englishMonthName,
                        style: AppTypography.bodyEn().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${today.gregorian.year}',
                        style: AppTypography.bodyEn().copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18, bottom: 14),
                  child: Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _AltCalendar(
                          labelEn: 'BANGLA',
                          dayMonthBn: today.bangla
                              .formatDayMonthBn(useBanglaNumerals: useBn),
                          yearBn: today.bangla
                              .yearBnFormatted(useBanglaNumerals: useBn),
                        ),
                      ),
                      Container(
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: _AltCalendar(
                            labelEn: 'হিজরি',
                            dayMonthBn: today.hijri
                                .formatDayMonthBn(useBanglaNumerals: useBn),
                            yearBn: today.hijri
                                .yearBnFormatted(useBanglaNumerals: useBn),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static LinearGradient _heroGradient({required bool isDark}) {
    if (isDark) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: <Color>[
          AppColors.brandEmerald,
          AppColors.brandEmeraldHeroDark2,
          AppColors.brandEmeraldHeroDark3,
        ],
        stops: <double>[0.0, 0.6, 1.0],
      );
    }
    return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: <Color>[
        AppColors.brandEmeraldHeroLight1,
        AppColors.brandEmerald,
        AppColors.brandEmeraldHeroLight3,
      ],
      stops: <double>[0.0, 0.5, 1.0],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.weekdayEn});

  final String weekdayEn;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _PulsingDot(),
            const SizedBox(width: 8),
            Text(
              'TODAY · আজ',
              style: AppTypography.captionEn().copyWith(
                color: Colors.white.withValues(alpha: 0.92),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          weekdayEn,
          style: AppTypography.bodySmEn().copyWith(
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _AltCalendar extends StatelessWidget {
  const _AltCalendar({
    required this.labelEn,
    required this.dayMonthBn,
    required this.yearBn,
  });

  final String labelEn;
  final String dayMonthBn;
  final String yearBn;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          labelEn,
          style: AppTypography.captionEn().copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            letterSpacing: 1.4,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayMonthBn,
          style: AppTypography.bodyBn().copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          yearBn,
          style: AppTypography.captionEn().copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 10,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Design system: today-dot pulse 2.4s ease-in-out infinite.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = Curves.easeInOut.transform(_controller.value);
        // Opacity 0.6 → 1.0 per design system.
        final double opacity = 0.6 + 0.4 * t;
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.45 * (1 - t)),
                blurRadius: 0,
                spreadRadius: 6 * t,
              ),
            ],
          ),
        );
      },
    );
  }
}
