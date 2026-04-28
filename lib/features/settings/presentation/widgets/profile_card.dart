import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Top-of-page profile card. The app does not yet have authentication —
/// this renders a "Sign in to sync" CTA with a guest avatar. When auth
/// lands, the same surface flips to the design's name + Pro badge layout.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: roles.bgSurface,
        borderRadius: AppRadii.xlBorder,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.xlBorder,
          child: Ink(
            decoration: BoxDecoration(
              color: roles.bgSurface,
              border: Border.all(color: roles.borderSubtle),
              borderRadius: AppRadii.xlBorder,
              boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                // Avatar — gradient emerald → gold per the design mockup.
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        AppColors.brandEmerald,
                        AppColors.brandGold,
                      ],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'অ',
                    style: AppTypography.h2Bn().copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'অতিথি',
                        style: AppTypography.h3Bn().copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: roles.fgPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'শীঘ্রই আসছে · Sign-in coming soon',
                        style: AppTypography.bodySmEn().copyWith(
                          fontSize: 12,
                          color: roles.fgTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 22,
                  color: roles.fgTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
