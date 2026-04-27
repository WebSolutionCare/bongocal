import 'package:flutter/material.dart';

import '../../../../shared/theme/theme.dart';

/// Dark gradient "Upgrade to Pro" promo card. Mirrors the `.pro-card`
/// block in BongoCal Settings.html — gold accents over a near-black
/// gradient with a subtle gold-foil corner wash.
class ProUpgradeCard extends StatelessWidget {
  const ProUpgradeCard({super.key, this.onUpgrade});

  final VoidCallback? onUpgrade;

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
              // Soft gold-foil corner wash.
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
                      mainAxisSize: MainAxisSize.min,
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'আরও সুন্দর, আরও স্মার্ট।',
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
                      'প্রিমিয়াম থিম, আনলিমিটেড রিমাইন্ডার, '
                      'এবং পরিবারের সাথে শেয়ার করার সুবিধা।',
                      style: AppTypography.bodyBn().copyWith(
                        fontSize: 13,
                        height: 1.55,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _ProBullet(label: '৮+ প্রিমিয়াম থিম'),
                    const SizedBox(height: 8),
                    const _ProBullet(
                      label: 'আনলিমিটেড রিমাইন্ডার ও ইভেন্ট',
                    ),
                    const SizedBox(height: 8),
                    const _ProBullet(label: 'পরিবারের সাথে শেয়ার (৬ জন পর্যন্ত)'),
                    const SizedBox(height: 8),
                    const _ProBullet(
                      label: 'বিজ্ঞাপন মুক্ত · iCloud + Drive sync',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton(
                        onPressed: onUpgrade,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brandGold,
                          foregroundColor: AppColors.gray900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Pro-তে আপগ্রেড করুন',
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
                        '৳২৯৯ / বছর · ৭ দিন বিনামূল্যে ট্রায়াল',
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

class _ProBullet extends StatelessWidget {
  const _ProBullet({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Icon(Icons.check, size: 14, color: AppColors.brandGold),
        const SizedBox(width: 8),
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
