import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../domain/entities/holiday_type.dart';

/// Horizontally-scrollable filter chips. The first chip is "All" (null
/// selection); each subsequent chip filters by [HolidayType] and shows the
/// count for that type.
class FilterChips extends StatelessWidget {
  const FilterChips({
    required this.totalCount,
    required this.counts,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final int totalCount;
  final Map<HolidayType, int> counts;
  final HolidayType? selected;
  final ValueChanged<HolidayType?> onSelect;

  static const List<HolidayType> _displayOrder = <HolidayType>[
    HolidayType.governmentNational,
    HolidayType.religious,
    HolidayType.international,
    HolidayType.optional,
    HolidayType.observance,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
        itemCount: _displayOrder.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (BuildContext context, int i) {
          if (i == 0) {
            return _Chip(
              label: 'সব',
              count: totalCount,
              isSelected: selected == null,
              onTap: () => onSelect(null),
            );
          }
          final HolidayType t = _displayOrder[i - 1];
          final int count = counts[t] ?? 0;
          if (count == 0) return const SizedBox.shrink();
          return _Chip(
            label: t.displayNameBn,
            count: count,
            isSelected: selected == t,
            onTap: () => onSelect(t),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final Color bg =
        isSelected ? AppColors.brandEmerald : roles.bgSurface;
    final Color fg =
        isSelected ? Colors.white : roles.fgSecondary;
    final Color border =
        isSelected ? AppColors.brandEmerald : roles.borderSubtle;

    return Material(
      color: bg,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: AppRadii.pillBorder,
            border: Border.all(color: border),
            boxShadow: isSelected
                ? const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33006A4E),
                      offset: Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '$count',
                style: AppTypography.bodySmEn().copyWith(
                  fontSize: 11,
                  color: fg.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
