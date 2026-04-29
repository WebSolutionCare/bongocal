import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';
import 'progress_dots.dart';

/// Shared chrome for every onboarding screen: SafeArea + top bar (progress
/// dots, optional Skip button) + body slot + bottom CTA slot. Each screen
/// composes this and supplies its own body / cta.
class OnboardingScreenLayout extends StatelessWidget {
  const OnboardingScreenLayout({
    required this.totalSteps,
    required this.currentStep,
    required this.body,
    required this.cta,
    this.onSkip,
    super.key,
  });

  final int totalSteps;
  final int currentStep;
  final Widget body;
  final Widget cta;

  /// When non-null, a "এড়িয়ে যান" button appears in the top-right and
  /// taps invoke this callback (typically jumps to the last screen).
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 8, 28, 24),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ProgressDots(
                    count: totalSteps,
                    activeIndex: currentStep,
                  ),
                  if (onSkip != null)
                    TextButton(
                      onPressed: onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: roles.fgSecondary,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        minimumSize: const Size(48, 48),
                      ),
                      child: Text(
                        'এড়িয়ে যান',
                        style: AppTypography.bodyBn().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: roles.fgSecondary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),
            Expanded(child: body),
            cta,
          ],
        ),
      ),
    );
  }
}
