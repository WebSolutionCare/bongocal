import 'package:flutter/material.dart';

import 'illustrations/bd_flag_illustration.dart';
import 'illustrations/boishakh_illustration.dart';
import 'illustrations/durga_illustration.dart';
import 'illustrations/eid_illustration.dart';

/// Maps `FestivalGreeting.illustrationKey` to the matching painter
/// widget. New festivals add a case here and a key in JSON.
class FestivalIllustration extends StatelessWidget {
  const FestivalIllustration({
    required this.illustrationKey,
    super.key,
    this.size = 220,
  });

  final String illustrationKey;
  final double size;

  @override
  Widget build(BuildContext context) {
    switch (illustrationKey) {
      case 'boishakh_alpana':
        return BoishakhIllustration(size: size);
      case 'eid_crescent':
        return EidIllustration(size: size);
      case 'bd_flag':
        return BdFlagIllustration(size: size);
      case 'durga_pattern':
        return DurgaIllustration(size: size);
      case 'christmas_star':
      default:
        // Generic gold star — a safe fallback for unknown keys.
        return SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: Icon(
              Icons.star,
              size: 140,
              color: Color(0xFFD4AF37),
            ),
          ),
        );
    }
  }
}
