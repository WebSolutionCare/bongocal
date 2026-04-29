import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Stack of three rotated calendar cards (Bangla / English / Hijri) with a
/// soft emerald glow + pulsing red dot. Mirrors the `.illus-1` block in
/// BongoCal Splash & Onboarding.html.
///
/// Uses `Transform.rotate` (visual rotation, not layout positioning) and
/// `Stack` + `Positioned` for offsets — no `Transform.translate`.
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Soft emerald radial glow behind the cards.
            const Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Color(0x1A006A4E),
                        Color(0x00006A4E),
                      ],
                      stops: <double>[0.0, 0.6],
                    ),
                  ),
                ),
              ),
            ),
            const _Card(
              dx: -78,
              dy: -8,
              rotationDeg: -9,
              accent: AppColors.brandRed,
              monthLabel: 'বৈশাখ',
              monthFontFamilyBangla: true,
              numberLabel: '১৪',
              wordLabel: 'নববর্ষ',
            ),
            const _Card(
              dx: 78,
              dy: -8,
              rotationDeg: 9,
              accent: AppColors.brandGold,
              accentFg: AppColors.brandGold700,
              monthLabel: 'যিলক্বদ',
              monthFontFamilyBangla: true,
              numberLabel: '৯',
              wordLabel: '১৪৪৭',
            ),
            const _Card(
              dx: 0,
              dy: 16,
              rotationDeg: -1,
              accent: AppColors.brandEmerald,
              monthLabel: 'APR',
              monthFontFamilyBangla: false,
              numberLabel: '27',
              wordLabel: 'Monday',
              wordFontFamilyBangla: false,
              numberInBrand: true,
            ),
            // Pulsing red mark in the lower-right.
            Positioned(
              right: 36,
              bottom: 40,
              child: _PulsingDot(color: roles.fgPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.dx,
    required this.dy,
    required this.rotationDeg,
    required this.accent,
    required this.monthLabel,
    required this.monthFontFamilyBangla,
    required this.numberLabel,
    required this.wordLabel,
    this.accentFg,
    this.wordFontFamilyBangla = true,
    this.numberInBrand = false,
  });

  final double dx;
  final double dy;
  final double rotationDeg;
  final Color accent;

  /// Foreground tint for the `monthLabel` (defaults to `accent`).
  final Color? accentFg;
  final String monthLabel;
  final bool monthFontFamilyBangla;
  final String numberLabel;
  final String wordLabel;
  final bool wordFontFamilyBangla;
  final bool numberInBrand;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color monthColor = accentFg ?? accent;

    return Align(
      alignment: Alignment(dx / 130, dy / 130),
      child: Transform.rotate(
        angle: rotationDeg * math.pi / 180,
        child: Container(
          width: 168,
          height: 212,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: roles.bgSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: roles.borderSubtle),
            boxShadow: isDark ? AppShadows.mdDark : AppShadows.mdLight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                monthLabel,
                style: (monthFontFamilyBangla
                        ? AppTypography.bodySmBn()
                        : AppTypography.captionEn())
                    .copyWith(
                  color: monthColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: monthFontFamilyBangla ? 0 : 0.96,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const Spacer(),
              Text(
                numberLabel,
                style: AppTypography.displayEn().copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -2.24,
                  height: 1,
                  color: numberInBrand ? accent : roles.fgPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                wordLabel,
                style: (wordFontFamilyBangla
                        ? AppTypography.bodySmBn()
                        : AppTypography.bodySmEn())
                    .copyWith(
                  fontSize: 13,
                  color: roles.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color});
  final Color color;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.brandRed.withValues(alpha: 0.5 + 0.5 * t),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}
