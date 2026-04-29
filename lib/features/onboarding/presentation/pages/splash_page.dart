import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/constants/app_info.dart';
import '../../../../shared/theme/theme.dart';
import '../providers/onboarding_provider.dart';

/// First-frame screen — emerald gradient + animated wordmark + tagline
/// + a tiny spinner. Stays visible for [splashMinDurationProvider] (2 s
/// in production, 0 in tests) then routes to either onboarding or home
/// depending on whether the user has finished onboarding before.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    // Run the min-display delay and the persisted-flag read in parallel.
    final Duration minDelay = ref.read(splashMinDurationProvider);
    final List<Object?> results = await Future.wait<Object?>(<Future<Object?>>[
      Future<void>.delayed(minDelay),
      ref.read(hasCompletedOnboardingProvider.future),
    ]);
    if (!mounted) return;
    final bool completed = results[1] as bool;
    context.go(completed ? AppRoutes.home : AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: <Color>[
              AppColors.brandEmeraldHeroLight1,
              AppColors.brandEmerald,
              AppColors.brandEmeraldHeroLight3,
            ],
            stops: <double>[0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Faint paisley accents in the corners.
            Positioned(
              right: -100,
              top: -100,
              child: IgnorePointer(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Color(0x33D4AF37),
                        Color(0x00D4AF37),
                      ],
                      stops: <double>[0.0, 0.6],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: -100,
              bottom: -100,
              child: IgnorePointer(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Color(0x1FF42A41),
                        Color(0x00F42A41),
                      ],
                      stops: <double>[0.0, 0.55],
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _animatedSlot(
                    delay: 0,
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'ক',
                        style: AppTypography.displayBn().copyWith(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _animatedSlot(
                    delay: 0.25,
                    child: Text(
                      AppInfo.displayNameEn,
                      style: AppTypography.displayEn().copyWith(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.72,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _animatedSlot(
                    delay: 0.45,
                    child: Text(
                      AppInfo.taglineBn,
                      style: AppTypography.bodyBn().copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 80,
              child: _animatedSlot(
                delay: 0.65,
                child: const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xCCFFFFFF)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _animatedSlot({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _intro,
      builder: (BuildContext context, Widget? c) {
        final double raw = (_intro.value - delay).clamp(0.0, 1.0) /
            (1.0 - delay).clamp(0.001, 1.0);
        final double t = Curves.easeOutCubic.transform(raw);
        return Opacity(
          opacity: t,
          child: Padding(
            padding: EdgeInsets.only(top: (1 - t) * 12),
            child: c,
          ),
        );
      },
      child: child,
    );
  }
}
