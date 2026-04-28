import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// White-surface card grouping one form question. Shows a numbered
/// eyebrow + title + optional sub-label, then [child] (the inputs), then
/// an optional inline error message.
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.number,
    required this.title,
    required this.child,
    this.subtitle,
    this.errorText,
    this.isRequired = false,
    super.key,
  });

  final int number;
  final String title;
  final String? subtitle;
  final Widget child;
  final String? errorText;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasError = errorText != null;

    return Container(
      decoration: BoxDecoration(
        color: roles.bgSurface,
        border: Border.all(
          color: hasError ? AppColors.brandRed : roles.borderSubtle,
          width: hasError ? 1.5 : 1,
        ),
        borderRadius: AppRadii.lgBorder,
        boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.brandEmerald.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$number',
                  style: AppTypography.bodySmEn().copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandEmerald,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: AppTypography.h3Bn().copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: roles.fgPrimary,
                      height: 1.3,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: title),
                      if (isRequired)
                        const TextSpan(
                          text: ' *',
                          style: TextStyle(color: AppColors.brandRed),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(
                subtitle!,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 12,
                  color: roles.fgTertiary,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          child,
          if (hasError) ...<Widget>[
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  size: 14,
                  color: AppColors.brandRed,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    errorText!,
                    style: AppTypography.bodySmBn().copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.brandRed,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
