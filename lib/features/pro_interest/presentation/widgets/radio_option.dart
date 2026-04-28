import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Single-select pill that shows an emerald check + tinted background
/// when chosen. The whole row is the tap target (≥ 48 px).
class RadioOption extends StatelessWidget {
  const RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.trailingBadge,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Optional trailing badge (e.g. gold "জনপ্রিয়" pill on the popular
  /// price tier).
  final Widget? trailingBadge;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isSelected
        ? (isDark ? const Color(0x29006A4E) : AppColors.brandEmerald50)
        : roles.bgSurface2;
    final Color border =
        isSelected ? AppColors.brandEmerald : roles.borderSubtle;
    final Color iconColor =
        isSelected ? AppColors.brandEmerald : roles.fgTertiary;

    return Material(
      color: bg,
      borderRadius: AppRadii.mdBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: border,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: AppRadii.mdBorder,
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: <Widget>[
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 2),
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.brandEmerald,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyBn().copyWith(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: roles.fgPrimary,
                  ),
                ),
              ),
              if (trailingBadge != null) ...<Widget>[
                const SizedBox(width: 8),
                trailingBadge!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
