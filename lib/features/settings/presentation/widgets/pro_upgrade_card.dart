import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Dark gradient "Pro coming soon" card. Replaces the prior "upgrade now"
/// CTA with an honest demand-validation prompt — tapping opens the Pro
/// interest form. Mirrors the `.pro-card` block in BongoCal Settings.html
/// (gold accents over a near-black gradient) but with a smoke-test CTA.
class ProUpgradeCard extends StatefulWidget {
  const ProUpgradeCard({super.key, this.onUpgrade});

  /// Tapping the CTA — wired by the settings page to push `/pro-interest`.
  final VoidCallback? onUpgrade;

  @override
  State<ProUpgradeCard> createState() => _ProUpgradeCardState();
}

class _ProUpgradeCardState extends State<ProUpgradeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.gray800,
                AppColors.gray900,
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: -50,
                top: -50,
                child: IgnorePointer(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          Color(0x66D4AF37),
                          Color(0x00D4AF37),
                        ],
                        stops: <double>[0.0, 0.7],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.brandGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'BONGOCAL PRO',
                          style: AppTypography.captionEn().copyWith(
                            color: AppColors.brandGold,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const Spacer(),
                        _PulsingComingSoonBadge(controller: _pulse),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'BongoCal Pro শীঘ্রই আসছে',
                      style: AppTypography.h2Bn().copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.22,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'আপনার মতামত আমাদের কাছে গুরুত্বপূর্ণ — '
                      'launch-এর আগে কী চান, কত দাম ঠিক, জানিয়ে দিন।',
                      style: AppTypography.bodyBn().copyWith(
                        fontSize: 13,
                        height: 1.55,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _ProBullet(label: 'কোনো বিজ্ঞাপন নেই'),
                    const SizedBox(height: 8),
                    const _ProBullet(label: 'ক্লাউড সিঙ্ক'),
                    const SizedBox(height: 8),
                    const _ProBullet(label: 'Family sharing'),
                    const SizedBox(height: 8),
                    const _ProBullet(label: 'Premium themes'),
                    const SizedBox(height: 8),
                    const _ProBullet(label: 'আরো অনেক কিছু...'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton(
                        onPressed: widget.onUpgrade,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brandGold,
                          foregroundColor: AppColors.gray900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'আপনার মতামত জানান →',
                          style: AppTypography.bodyBn().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '১ মিনিটের সংক্ষিপ্ত প্রশ্নাবলী',
                        style: AppTypography.bodySmEn().copyWith(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PulsingComingSoonBadge extends StatelessWidget {
  const _PulsingComingSoonBadge({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? _) {
        final double t = Curves.easeInOut.transform(controller.value);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.brandGold.withValues(alpha: 0.18 + 0.10 * t),
            border: Border.all(
              color: AppColors.brandGold.withValues(alpha: 0.45 + 0.30 * t),
            ),
            borderRadius: AppRadii.pillBorder,
          ),
          child: Text(
            'শীঘ্রই',
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.brandGold,
            ),
          ),
        );
      },
    );
  }
}

class _ProBullet extends StatelessWidget {
  const _ProBullet({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7, right: 10),
          decoration: const BoxDecoration(
            color: AppColors.brandGold,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyBn().copyWith(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ),
      ],
    );
  }
}
