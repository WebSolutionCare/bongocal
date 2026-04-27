import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Color tone for the small icon chip on a settings tile. Mirrors the
/// design's `.ic-em / .ic-rd / .ic-gd / .ic-bl / .ic-pr / .ic-gy` palette.
enum SettingsIconTone { emerald, red, gold, info, purple, gray }

/// A single row inside a [SettingsSection]: leading icon chip, label
/// (+ optional sub-label), and a trailing widget (value text + chevron, a
/// switch, a segmented control, or a trailing chev-circ).
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.tone,
    required this.label,
    this.subLabel,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    super.key,
  });

  final IconData icon;
  final SettingsIconTone tone;
  final String label;
  final String? subLabel;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// True for the destructive Sign-Out row. Tints the label + icon red.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final (Color iconBg, Color iconFg) =
        _palette(tone, isDark: isDark, isDestructive: isDestructive);
    final Color labelColor = isDestructive
        ? (isDark ? const Color(0xFFFF8A98) : AppColors.brandRed)
        : roles.fgPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconFg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      label,
                      style: AppTypography.bodyBn().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: labelColor,
                      ),
                    ),
                    if (subLabel != null) ...<Widget>[
                      const SizedBox(height: 1),
                      Text(
                        subLabel!,
                        style: AppTypography.bodySmEn().copyWith(
                          fontSize: 11,
                          color: roles.fgTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  static (Color, Color) _palette(
    SettingsIconTone tone, {
    required bool isDark,
    required bool isDestructive,
  }) {
    if (isDestructive) {
      return (
        isDark ? const Color(0x29F42A41) : AppColors.brandRed50,
        isDark ? const Color(0xFFFF8A98) : AppColors.brandRed,
      );
    }
    switch (tone) {
      case SettingsIconTone.emerald:
        return (
          isDark ? const Color(0x2E006A4E) : AppColors.brandEmerald50,
          isDark ? const Color(0xFF4FB394) : AppColors.brandEmerald,
        );
      case SettingsIconTone.red:
        return (
          isDark ? const Color(0x29F42A41) : AppColors.brandRed50,
          isDark ? const Color(0xFFFF8A98) : AppColors.brandRed700,
        );
      case SettingsIconTone.gold:
        return (
          isDark ? const Color(0x29D4AF37) : AppColors.brandGold50,
          isDark ? const Color(0xFFE8C969) : AppColors.brandGold700,
        );
      case SettingsIconTone.info:
        return (
          isDark ? const Color(0x331E6FBE) : AppColors.infoTint,
          isDark ? const Color(0xFF5FA3DD) : AppColors.info,
        );
      case SettingsIconTone.purple:
        return (
          isDark ? const Color(0x337A4FD4) : const Color(0x1A7A4FD4),
          isDark ? const Color(0xFFB49DEB) : const Color(0xFF7A4FD4),
        );
      case SettingsIconTone.gray:
        return (
          isDark ? AppColors.darkBgSurface2 : AppColors.gray100,
          isDark ? AppColors.darkFgSecondary : AppColors.lightFgSecondary,
        );
    }
  }
}

/// Trailing widget: label + chevron — used when the tile opens a picker.
class SettingsValueTrailing extends StatelessWidget {
  const SettingsValueTrailing({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          text,
          style: AppTypography.bodySmBn().copyWith(
            fontSize: 13,
            color: roles.fgTertiary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, size: 18, color: roles.fgTertiary),
      ],
    );
  }
}

/// Trailing widget: a single chev-circ for navigation rows that have no
/// inline value (About, Sign out, etc.).
class SettingsChevTrailing extends StatelessWidget {
  const SettingsChevTrailing({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Icon(Icons.chevron_right, size: 18, color: roles.fgTertiary);
  }
}
