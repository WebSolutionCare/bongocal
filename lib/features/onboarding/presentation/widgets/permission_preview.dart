import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Animated bell + frosted notification card mockup for the permission
/// screen. The bell shakes on a 3.5 s loop; the card slides in from below.
class PermissionPreview extends StatefulWidget {
  const PermissionPreview({super.key});

  @override
  State<PermissionPreview> createState() => _PermissionPreviewState();
}

class _PermissionPreviewState extends State<PermissionPreview>
    with TickerProviderStateMixin {
  late final AnimationController _shake;
  late final AnimationController _slide;

  @override
  void initState() {
    super.initState();
    _shake = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
    _slide = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _shake.dispose();
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: <Color>[
                      AppColors.brandEmerald.withValues(alpha: 0.08),
                      AppColors.brandEmerald.withValues(alpha: 0.0),
                    ],
                    stops: const <double>[0.0, 0.6],
                  ),
                ),
              ),
            ),
          ),
          // Bell.
          Align(
            alignment: const Alignment(0, -0.4),
            child: AnimatedBuilder(
              animation: _shake,
              builder: (BuildContext context, Widget? child) {
                final double t = _shake.value;
                // Shake in the last 14% of the loop (matches the design's
                // 80%-94% keyframe range).
                double angle = 0;
                if (t > 0.80 && t < 0.94) {
                  final double phase = (t - 0.80) / 0.14;
                  angle = 0.22 *
                      (phase < 0.25
                          ? -phase * 4
                          : phase < 0.5
                              ? (phase - 0.25) * 4 - 1
                              : phase < 0.75
                                  ? -(phase - 0.5) * 4 + 1
                                  : (phase - 0.75) * 4 - 1);
                }
                return Transform.rotate(angle: angle, child: child);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.brandEmerald,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x59006A4E),
                      offset: Offset(0, 12),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Notification preview card.
          Positioned(
            left: 12,
            right: 12,
            bottom: 8,
            child: AnimatedBuilder(
              animation: _slide,
              builder: (BuildContext context, Widget? child) => Opacity(
                opacity: Curves.easeOutCubic.transform(_slide.value),
                child: child,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
                    decoration: BoxDecoration(
                      color: roles.bgSurface.withValues(alpha: 0.85),
                      border: Border.all(color: roles.borderSubtle),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x1A141413),
                          offset: Offset(0, 8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.brandEmerald,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'BongoCal',
                                    style: AppTypography.bodySmEn().copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: roles.fgPrimary,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'এখন',
                                    style: AppTypography.bodySmBn().copyWith(
                                      fontSize: 11,
                                      color: roles.fgTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'আগামীকাল পহেলা বৈশাখ',
                                style: AppTypography.bodySmBn().copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: roles.fgPrimary,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'নতুন বছর ১৪৩৩ — পরিবার ও বন্ধুদের শুভেচ্ছা '
                                'জানাতে প্রস্তুত হোন।',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmBn().copyWith(
                                  fontSize: 13,
                                  color: roles.fgSecondary,
                                  height: 1.4,
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
            ),
          ),
        ],
      ),
    );
  }
}
