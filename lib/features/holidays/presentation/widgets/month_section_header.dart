import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../../calendar/domain/entities/calendar_date.dart';

/// Section header used to group holidays by Gregorian month on the list.
/// Shows `April 2026 · বৈশাখ ১৪৩৩` plus a count of items in the section.
class MonthSectionHeader extends StatelessWidget {
  const MonthSectionHeader({
    required this.monthLabelEn,
    required this.monthLabelBn,
    required this.count,
    super.key,
  });

  /// e.g. `April 2026`.
  final String monthLabelEn;

  /// e.g. `বৈশাখ ১৪৩৩` — the Bengali month range that overlaps this Gregorian month.
  final String monthLabelBn;
  final int count;

  /// Convenience: build [monthLabelEn] from a year + month.
  static String formatEn(int year, int month) =>
      '${englishMonthNames[month - 1]} $year';

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            monthLabelEn,
            style: AppTypography.h3En().copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: roles.fgPrimary,
              letterSpacing: -0.075,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              monthLabelBn,
              style: AppTypography.bodySmBn().copyWith(
                fontSize: 12,
                color: roles.fgTertiary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$count',
            style: AppTypography.captionEn().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: roles.fgTertiary,
              letterSpacing: 0.66,
            ),
          ),
        ],
      ),
    );
  }
}
