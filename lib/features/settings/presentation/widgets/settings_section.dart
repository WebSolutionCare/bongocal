import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// A grouped iOS-style settings section: bold uppercase header + a rounded
/// surface containing tile rows.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.titleBn,
    required this.titleEn,
    required this.children,
    super.key,
  });

  final String titleBn;
  final String titleEn;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
            child: Text(
              '$titleBn · $titleEn'.toUpperCase(),
              style: AppTypography.captionEn().copyWith(
                color: roles.fgTertiary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.88,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: roles.bgSurface,
              borderRadius: AppRadii.lgBorder,
              border: Border.all(color: roles.borderSubtle),
              boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
            ),
            child: ClipRRect(
              borderRadius: AppRadii.lgBorder,
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < children.length; i++) ...<Widget>[
                    children[i],
                    if (i < children.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: roles.borderSubtle,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
