import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import '../../domain/entities/event_category.dart';

/// 5-tile category grid (emoji + Bangla label). Mirrors the `.cat-grid`
/// block on the add-event sheet mockup.
class CategoryPicker extends StatelessWidget {
  const CategoryPicker({
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final EventCategory selected;
  final ValueChanged<EventCategory> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.95,
      children: <Widget>[
        for (final EventCategory c in EventCategory.values)
          _CategoryTile(
            category: c,
            isSelected: c == selected,
            onTap: () => onSelect(c),
          ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final EventCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isSelected
        ? (isDark ? const Color(0x2E006A4E) : AppColors.brandEmerald50)
        : roles.bgSurface2;
    final Color borderColor = isSelected
        ? AppColors.brandEmerald
        : roles.borderSubtle;
    final Color labelColor = isSelected
        ? (isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald)
        : roles.fgSecondary;

    return Material(
      color: bg,
      borderRadius: AppRadii.mdBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: borderColor),
            borderRadius: AppRadii.mdBorder,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                category.emoji,
                style: const TextStyle(fontSize: 22, height: 1),
              ),
              const SizedBox(height: 4),
              Text(
                category.displayBn,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 10,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: labelColor,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
