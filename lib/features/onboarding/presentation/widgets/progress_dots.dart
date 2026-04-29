import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Animated progress indicator — the active dot stretches to a 22 px pill
/// in emerald, idle dots stay 6 px gray. Mirrors the `.dots / .dot.on`
/// pattern in BongoCal Splash & Onboarding.html.
class ProgressDots extends StatelessWidget {
  const ProgressDots({
    required this.count,
    required this.activeIndex,
    super.key,
  })  : assert(count > 0, 'count must be positive'),
        assert(activeIndex >= 0, 'activeIndex must be non-negative');

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < count; i++) ...<Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: i == activeIndex ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? AppColors.brandEmerald
                  : roles.borderStrong.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (i < count - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}
