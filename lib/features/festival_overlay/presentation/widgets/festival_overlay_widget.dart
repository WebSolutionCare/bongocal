import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/bangla_numerals.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/festival_greeting.dart';
import 'festival_illustration.dart';

/// Full-screen festival greeting. Auto-dismisses after [autoDismissAfter];
/// any tap outside the explicit Skip / "শুরু করুন" affordance also
/// dismisses early. The widget is intentionally self-contained — it owns
/// its animation controllers + auto-dismiss timer so the wrapper only
/// has to swap it in / out.
class FestivalOverlayWidget extends StatefulWidget {
  const FestivalOverlayWidget({
    required this.greeting,
    required this.today,
    required this.onDismiss,
    super.key,
    this.autoDismissAfter = const Duration(seconds: 5),
  });

  final FestivalGreeting greeting;
  final DateTime today;
  final VoidCallback onDismiss;
  final Duration autoDismissAfter;

  @override
  State<FestivalOverlayWidget> createState() => _FestivalOverlayWidgetState();
}

class _FestivalOverlayWidgetState extends State<FestivalOverlayWidget>
    with TickerProviderStateMixin {
  late final AnimationController _entry;
  late final Animation<double> _bgFade;
  late final Animation<double> _illustrationRise;
  late final Animation<double> _textReveal;
  Timer? _autoDismiss;

  @override
  void initState() {
    super.initState();
    _entry = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgFade = CurvedAnimation(
      parent: _entry,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _illustrationRise = CurvedAnimation(
      parent: _entry,
      curve: const Interval(0.20, 0.75, curve: Curves.easeOutCubic),
    );
    _textReveal = CurvedAnimation(
      parent: _entry,
      curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
    );
    _entry.forward();
    _autoDismiss = Timer(widget.autoDismissAfter, _dismiss);
  }

  @override
  void dispose() {
    _autoDismiss?.cancel();
    _entry.dispose();
    super.dispose();
  }

  void _dismiss() {
    _autoDismiss?.cancel();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final FestivalGreeting g = widget.greeting;
    final String dateBn = _formatDateBn(widget.today);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _dismiss,
        child: AnimatedBuilder(
          animation: _entry,
          builder: (BuildContext context, Widget? child) {
            return Opacity(opacity: _bgFade.value, child: child);
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[g.gradientStart, g.gradientEnd],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 8,
                    right: 8,
                    child: TextButton(
                      onPressed: _dismiss,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white.withValues(alpha: 0.9),
                      ),
                      child: const Text('এড়িয়ে যান'),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AnimatedBuilder(
                            animation: _illustrationRise,
                            builder: (BuildContext _, Widget? c) {
                              final double t = _illustrationRise.value;
                              return Opacity(
                                opacity: t,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 28 + (1 - t) * 16,
                                  ),
                                  child: c,
                                ),
                              );
                            },
                            child: FestivalIllustration(
                              illustrationKey: g.illustrationKey,
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _textReveal,
                            builder: (BuildContext _, Widget? c) =>
                                Opacity(opacity: _textReveal.value, child: c),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  g.nameBn,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.h1Bn().copyWith(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.15,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  g.nameEn,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyEn().copyWith(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.85),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  g.greetingBn,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodyBn().copyWith(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.92),
                                    height: 1.55,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  dateBn,
                                  textAlign: TextAlign.center,
                                  style: AppTypography.bodySmBn().copyWith(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.78),
                                    letterSpacing: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 32,
                    child: AnimatedBuilder(
                      animation: _textReveal,
                      builder: (BuildContext _, Widget? c) =>
                          Opacity(opacity: _textReveal.value, child: c),
                      child: Center(
                        child: TextButton(
                          onPressed: _dismiss,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.18),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'শুরু করুন',
                            style: AppTypography.bodyBn().copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static const List<String> _bnMonths = <String>[
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর',
  ];

  static String _formatDateBn(DateTime d) {
    final String day = BanglaNumerals.fromInt(d.day);
    final String year = BanglaNumerals.fromInt(d.year);
    return '$day ${_bnMonths[d.month - 1]} $year';
  }
}
