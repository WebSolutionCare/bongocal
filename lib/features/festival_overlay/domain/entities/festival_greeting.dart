import 'dart:ui' show Color;

import 'package:equatable/equatable.dart';

import 'festival_theme.dart';

/// Static metadata for a single festival's greeting screen. The [id]
/// matches the [Holiday.id] so a date-based holiday match resolves
/// directly to a greeting.
class FestivalGreeting extends Equatable {
  const FestivalGreeting({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.greetingBn,
    required this.greetingEn,
    required this.theme,
    required this.gradientStart,
    required this.gradientEnd,
    required this.illustrationKey,
  });

  /// Stable id — equal to the matching [Holiday.id].
  final String id;
  final String nameBn;
  final String nameEn;

  /// One-line greeting body in Bangla. "আপনি" form, no emoji.
  final String greetingBn;
  final String greetingEn;

  final FestivalTheme theme;

  /// Top-left of the full-screen gradient.
  final Color gradientStart;

  /// Bottom-right of the gradient.
  final Color gradientEnd;

  /// Picks an illustration widget at render time. Names map 1:1 to the
  /// switch in `FestivalIllustration`.
  final String illustrationKey;

  @override
  List<Object?> get props => <Object?>[
        id,
        nameBn,
        nameEn,
        greetingBn,
        greetingEn,
        theme,
        gradientStart.toARGB32(),
        gradientEnd.toARGB32(),
        illustrationKey,
      ];
}
