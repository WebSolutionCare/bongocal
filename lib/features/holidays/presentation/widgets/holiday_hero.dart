import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';

/// Magazine-style hero used at the top of the holiday detail page. The
/// gradient palette tracks the holiday's [HolidayType] so each detail page
/// has a distinct vibe — gold-warm for religious, red-warm for national,
/// emerald for international, neutral for optional/observance.
class HolidayHero extends StatelessWidget {
  const HolidayHero({
    required this.holiday,
    required this.banglaShort,
    required this.weekdayEn,
    required this.onBack,
    super.key,
  });

  final Holiday holiday;
  final String banglaShort; // e.g. `১ বৈশাখ ১৪৩৩`
  final String weekdayEn; // e.g. `Tuesday`
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final _HeroPalette palette = _HeroPalette.of(holiday.type);
    return SizedBox(
      height: 360,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 1.0,
                  colors: palette.colors,
                  stops: palette.stops,
                ),
              ),
            ),
          ),
          // Concentric alpana-style rings + sun rays.
          const Positioned.fill(
            child: IgnorePointer(child: _AlpanaArt()),
          ),
          // Vignette to bottom for legibility.
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                    stops: const <double>[0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Top bar — back button, status-bar safe area.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: <Widget>[
                    _GlassIconButton(icon: Icons.arrow_back, onTap: onBack),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          // Bottom-left footer copy.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _TypeBadge(type: holiday.type),
                  const SizedBox(height: 12),
                  Text(
                    holiday.nameBn,
                    style: AppTypography.h1Bn().copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.38,
                      height: 1.05,
                      color: Colors.white,
                      shadows: const <Shadow>[
                        Shadow(
                          color: Color(0x59000000),
                          offset: Offset(0, 2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    holiday.nameEn,
                    style: AppTypography.bodySmEn().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                      letterSpacing: 0.07,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Single Text avoids the divider stranding on its own line
                  // when the English string wraps in a `Wrap`. The bullet
                  // separator preserves the visual rhythm at narrow widths.
                  Text(
                    '$banglaShort  ·  ${holiday.date.day} '
                    '${_monthLong(holiday.date.month)} '
                    '${holiday.date.year} · $weekdayEn',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyBn().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _monthLong(int month) {
    const List<String> names = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month - 1];
  }
}

class _AlpanaArt extends StatelessWidget {
  const _AlpanaArt();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _AlpanaPainter());
}

class _AlpanaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height * 0.32);
    final Paint ring = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, 60.0 * i, ring);
    }
    final Paint ray = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 16; i++) {
      final double a = (i / 16) * 2 * math.pi;
      const double r1 = 80;
      final double r2 = i.isEven ? 130 : 110;
      canvas.drawLine(
        center + Offset(r1 * math.cos(a), r1 * math.sin(a)),
        center + Offset(r2 * math.cos(a), r2 * math.sin(a)),
        ray,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final HolidayType type;

  @override
  Widget build(BuildContext context) {
    final String label =
        '${type.displayNameBn} · ${type.displayNameEn}';
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
        borderRadius: AppRadii.pillBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _HeroPalette {
  const _HeroPalette({required this.colors, required this.stops});

  factory _HeroPalette.of(HolidayType type) {
    switch (type) {
      case HolidayType.religious:
        return const _HeroPalette(
          colors: <Color>[
            Color(0xFFFDB52A),
            Color(0xFFF26A2E),
            Color(0xFFC71F33),
            Color(0xFF6E1018),
          ],
          stops: <double>[0.0, 0.30, 0.65, 1.0],
        );
      case HolidayType.governmentNational:
        return const _HeroPalette(
          colors: <Color>[
            Color(0xFFFFD27A),
            Color(0xFFE05C2A),
            Color(0xFFB5172A),
            Color(0xFF4A0911),
          ],
          stops: <double>[0.0, 0.32, 0.66, 1.0],
        );
      case HolidayType.international:
        return const _HeroPalette(
          colors: <Color>[
            Color(0xFFD4AF37),
            Color(0xFF008A66),
            Color(0xFF006A4E),
            Color(0xFF003B2C),
          ],
          stops: <double>[0.0, 0.32, 0.66, 1.0],
        );
      case HolidayType.optional:
      case HolidayType.observance:
        return const _HeroPalette(
          colors: <Color>[
            Color(0xFF767670),
            Color(0xFF535350),
            Color(0xFF3A3A38),
            Color(0xFF141413),
          ],
          stops: <double>[0.0, 0.34, 0.7, 1.0],
        );
    }
  }

  final List<Color> colors;
  final List<double> stops;
}
