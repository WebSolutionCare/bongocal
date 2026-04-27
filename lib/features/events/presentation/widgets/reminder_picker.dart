import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Predefined reminder offsets the user can toggle on/off.
const List<int> kReminderPresetMinutes = <int>[15, 60, 1440, 10080];

/// Display label for a [minutesBefore] offset (Bangla).
String reminderLabelBn(int minutesBefore) {
  switch (minutesBefore) {
    case 15:
      return '১৫ মিনিট আগে';
    case 60:
      return '১ ঘণ্টা আগে';
    case 1440:
      return '১ দিন আগে';
    case 10080:
      return '১ সপ্তাহ আগে';
    default:
      return '$minutesBefore min';
  }
}

class ReminderPicker extends StatelessWidget {
  const ReminderPicker({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final Set<int> selected;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        for (final int m in kReminderPresetMinutes)
          _ReminderChip(
            label: reminderLabelBn(m),
            isSelected: selected.contains(m),
            onTap: () => onToggle(m),
          ),
      ],
    );
  }
}

class _ReminderChip extends StatelessWidget {
  const _ReminderChip({
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
    final Color bg = isSelected ? AppColors.brandEmerald : roles.bgSurface;
    final Color fg = isSelected ? Colors.white : roles.fgSecondary;
    final Color borderColor =
        isSelected ? AppColors.brandEmerald : roles.borderDefault;

    return Material(
      color: bg,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: borderColor),
            borderRadius: AppRadii.pillBorder,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}
