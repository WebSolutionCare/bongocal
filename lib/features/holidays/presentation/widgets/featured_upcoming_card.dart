import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../calendar/domain/entities/calendar_date.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';

/// "পরবর্তী ছুটি · Next up" card with a soft-red gradient, a pulsing eyebrow,
/// the holiday name, a description, and a big countdown number to the right.
/// Mirrors `.featured` block on the holidays list mockup.
class FeaturedUpcomingCard extends ConsumerWidget {
  const FeaturedUpcomingCard({
    required this.holiday,
    required this.daysAway,
    required this.banglaFullDate,
    required this.hijriFullDate,
    required this.onShare,
    required this.onTap,
    super.key,
  });

  final Holiday holiday;
  final int daysAway;
  final String banglaFullDate;
  final String hijriFullDate;
  final VoidCallback onShare;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent =
        isDark ? const Color(0xFFFF6B7C) : AppColors.brandRed;

    return Material(
      borderRadius: BorderRadius.circular(22),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: roles.borderSubtle),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: isDark
                  ? const <Color>[Color(0xFF2A1F1F), Color(0xFF232322)]
                  : const <Color>[Color(0xFFFFF8F2), Color(0xFFFFFFFF)],
              stops: const <double>[0.0, 1.0],
            ),
            boxShadow: isDark ? AppShadows.mdDark : AppShadows.mdLight,
          ),
          child: Stack(
            children: <Widget>[
              // soft red wash in upper-right
              Positioned(
                right: -40,
                top: -40,
                child: IgnorePointer(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          Color(0x33F42A41),
                          Color(0x00F42A41),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // type-colored accent stripe on the left
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 4, color: accent),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _Eyebrow(accent: accent),
                    const SizedBox(height: 8),
                    Text(
                      holiday.nameBn,
                      style: AppTypography.h2Bn().copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: roles.fgPrimary,
                        letterSpacing: -0.22,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      holiday.nameEn,
                      style: AppTypography.bodySmEn().copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: roles.fgTertiary,
                      ),
                    ),
                    if (holiday.descriptionBn.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        holiday.descriptionBn,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyBn().copyWith(
                          fontSize: 13,
                          height: 1.55,
                          color: roles.fgSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      color: roles.borderSubtle,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _englishLong(holiday.date),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodyEn().copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: roles.fgPrimary,
                                  letterSpacing: -0.16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$banglaFullDate · $hijriFullDate',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmBn().copyWith(
                                  fontSize: 12,
                                  color: roles.fgSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              digits(daysAway),
                              style: AppTypography.h1En().copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: accent,
                                letterSpacing: -0.56,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'দিন বাকি',
                              style: AppTypography.bodySmBn().copyWith(
                                fontSize: 11,
                                color: roles.fgTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            holiday.isGovernmentHoliday
                                ? 'সরকারি ছুটি · দেশজুড়ে'
                                : holiday.type.displayNameBn,
                            style: AppTypography.bodySmBn().copyWith(
                              fontSize: 12,
                              color: roles.fgSecondary,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: onShare,
                          style: TextButton.styleFrom(
                            backgroundColor: roles.bgSurface2,
                            foregroundColor: roles.fgPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: AppRadii.mdBorder,
                            ),
                          ),
                          icon: const Icon(Icons.ios_share, size: 14),
                          label: Text(
                            'শেয়ার',
                            style: AppTypography.bodySmBn().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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

  static String _englishLong(DateTime d) {
    const List<String> weekdays = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${englishMonthNames[d.month - 1]}';
  }
}

class _Eyebrow extends StatefulWidget {
  const _Eyebrow({required this.accent});

  final Color accent;

  @override
  State<_Eyebrow> createState() => _EyebrowState();
}

class _EyebrowState extends State<_Eyebrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final double t = Curves.easeInOut.transform(_controller.value);
            return Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: widget.accent.withValues(alpha: 0.6 + 0.4 * t),
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: widget.accent.withValues(alpha: 0.5 * (1 - t)),
                    blurRadius: 0,
                    spreadRadius: 5 * t,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 6),
        Text(
          'পরবর্তী ছুটি · NEXT UP',
          style: AppTypography.captionEn().copyWith(
            color: widget.accent,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
