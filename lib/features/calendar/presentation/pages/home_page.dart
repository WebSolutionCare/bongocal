import 'package:flutter/material.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/utils/date_extensions.dart';
import '../../../../shared/theme/theme.dart';

/// Placeholder home page used to verify theme + font wiring during setup.
///
/// Phase 1 replaces this with the real home: today header, agenda preview,
/// prayer times, weather. Until then it shows the brand wordmark in
/// emerald + Hind Siliguri to confirm tokens are flowing through correctly.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    final today = DateTime.now();

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppSpacing.s8),
              Text(
                AppInfo.displayNameEn,
                style: AppTypography.displayEn().copyWith(
                  color: AppColors.brandEmerald,
                ),
              ),
              const SizedBox(height: AppSpacing.s1),
              Text(
                AppInfo.displayNameBn,
                style: AppTypography.h1Bn().copyWith(
                  color: AppColors.brandEmerald,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              Text(
                AppInfo.taglineBn,
                style: AppTypography.bodyBn().copyWith(
                  color: roles.fgSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                'আজ',
                style: AppTypography.captionEn().copyWith(
                  color: roles.fgTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                today.formatBengali(),
                style: AppTypography.h2Bn().copyWith(
                  color: roles.fgPrimary,
                ),
              ),
              Text(
                today.formatEnglish(),
                style: AppTypography.bodyEn().copyWith(
                  color: roles.fgSecondary,
                ),
              ),
              Text(
                today.formatHijriBangla(),
                style: AppTypography.bodyBn().copyWith(
                  color: roles.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
