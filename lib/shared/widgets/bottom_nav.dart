import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Translucent bottom nav matching design-system layout rules: 64px high,
/// safe-area inset, 80% surface fill, `backdrop-blur(20px)`. Selected item
/// uses brand emerald; inactive items use `fg-tertiary`.
class BottomNav extends StatelessWidget {
  const BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: roles.bgSurface.withValues(alpha: 0.8),
            border: Border(top: BorderSide(color: roles.borderSubtle)),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: AppSpacing.bottomNavHeight,
              child: Row(
                children: <Widget>[
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavTile(
                        item: items[i],
                        selected: i == currentIndex,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem {
  const BottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    final fg = selected ? AppColors.brandEmerald : roles.fgTertiary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(item.icon, size: 24, color: fg),
          const SizedBox(height: 2),
          Text(
            item.label,
            style: AppTypography.bodySmBn().copyWith(
              color: fg,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
