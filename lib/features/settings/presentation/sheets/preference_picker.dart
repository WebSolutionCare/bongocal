import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Generic single-select bottom-sheet picker. Used by the settings page for
/// week-start day, primary-calendar, reminder timing, etc.
///
/// Returns the chosen option, or `null` if dismissed.
Future<T?> showPreferencePicker<T>({
  required BuildContext context,
  required String title,
  required List<T> options,
  required T selected,
  required String Function(T) labelOf,
  String Function(T)? subLabelOf,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) => _PreferencePicker<T>(
      title: title,
      options: options,
      selected: selected,
      labelOf: labelOf,
      subLabelOf: subLabelOf,
    ),
  );
}

class _PreferencePicker<T> extends StatelessWidget {
  const _PreferencePicker({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelOf,
    this.subLabelOf,
  });

  final String title;
  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final String Function(T)? subLabelOf;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: roles.bgSurface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 5,
            decoration: BoxDecoration(
              color: roles.borderStrong,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.h3Bn().copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: roles.fgPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'বাতিল',
                    style: AppTypography.bodyBn().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: roles.fgSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          for (final T option in options)
            _Option<T>(
              option: option,
              isSelected: option == selected,
              label: labelOf(option),
              subLabel: subLabelOf?.call(option),
              onTap: () => Navigator.of(context).pop(option),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _Option<T> extends StatelessWidget {
  const _Option({
    required this.option,
    required this.isSelected,
    required this.label,
    required this.onTap,
    this.subLabel,
  });

  final T option;
  final bool isSelected;
  final String label;
  final String? subLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    style: AppTypography.bodyBn().copyWith(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.brandEmerald
                          : roles.fgPrimary,
                    ),
                  ),
                  if (subLabel != null) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      subLabel!,
                      style: AppTypography.bodySmEn().copyWith(
                        fontSize: 12,
                        color: roles.fgTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.brandEmerald,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
