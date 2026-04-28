import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

class CheckboxOption extends StatelessWidget {
  const CheckboxOption({
    required this.label,
    required this.isChecked,
    required this.onToggle,
    super.key,
  });

  final String label;
  final bool isChecked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isChecked
        ? (isDark ? const Color(0x29006A4E) : AppColors.brandEmerald50)
        : roles.bgSurface2;
    final Color border =
        isChecked ? AppColors.brandEmerald : roles.borderSubtle;

    return Material(
      color: bg,
      borderRadius: AppRadii.mdBorder,
      child: InkWell(
        onTap: onToggle,
        borderRadius: AppRadii.mdBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: border,
              width: isChecked ? 1.5 : 1,
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
                  color: isChecked ? AppColors.brandEmerald : Colors.transparent,
                  border: Border.all(
                    color: isChecked
                        ? AppColors.brandEmerald
                        : roles.fgTertiary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: isChecked
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyBn().copyWith(
                    fontSize: 14,
                    fontWeight:
                        isChecked ? FontWeight.w600 : FontWeight.w500,
                    color: roles.fgPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
