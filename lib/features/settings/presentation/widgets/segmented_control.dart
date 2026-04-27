import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Inline segmented pill used as the trailing widget on a [SettingsTile]
/// when the choice has 2–3 options that fit on one line.
class InlineSegmentedControl<T> extends StatelessWidget {
  const InlineSegmentedControl({
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.labelOf,
    super.key,
  });

  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelect;
  final String Function(T) labelOf;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: roles.bgSurface2,
        borderRadius: AppRadii.pillBorder,
        border: Border.all(color: roles.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final T option in options)
            _Segment(
              label: labelOf(option),
              isSelected: option == selected,
              onTap: () => onSelect(option),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isSelected ? roles.bgSurface : Colors.transparent,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadii.pillBorder,
            boxShadow: isSelected
                ? (isDark ? AppShadows.xsDark : AppShadows.xsLight)
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: AppTypography.bodySmEn().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? roles.fgPrimary : roles.fgTertiary,
            ),
          ),
        ),
      ),
    );
  }
}
