import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/presentation/providers/settings_provider.dart';
import '../theme/theme.dart';

/// A single calendar grid cell. Renders the Gregorian day number, an optional
/// secondary Bengali/Hijri overlay, today's red accent, and a small gold disc
/// for festival days.
///
/// Stub: layout is final but month-cell tap interactions and ripple are
/// wired up in the calendar feature.
class DateCell extends ConsumerWidget {
  const DateCell({
    required this.date,
    this.secondary,
    this.isToday = false,
    this.isSelected = false,
    this.isFestival = false,
    this.isOutsideMonth = false,
    this.onTap,
    super.key,
  });

  final DateTime date;
  final String? secondary;
  final bool isToday;
  final bool isSelected;
  final bool isFestival;
  final bool isOutsideMonth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final String dayBn = digits(date.day);

    final fg = isOutsideMonth
        ? roles.fgTertiary
        : isToday
            ? AppColors.brandRed
            : roles.fgPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smBorder,
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (isSelected)
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.brandEmerald100,
                  borderRadius: AppRadii.smBorder,
                ),
                child: SizedBox.expand(),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  dayBn,
                  style: AppTypography.bodyBn().copyWith(
                    color: fg,
                    fontWeight:
                        isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                if (secondary != null)
                  Text(
                    secondary!,
                    style: AppTypography.captionEn().copyWith(
                      color: roles.fgTertiary,
                      // Caption tokens are uppercase Latin only; an explicit
                      // override here lets a Bangla secondary number render
                      // without uppercasing.
                      letterSpacing: 0,
                    ),
                  ),
              ],
            ),
            if (isFestival)
              Positioned(
                bottom: 6,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.brandGold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
