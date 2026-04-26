import 'package:flutter/widgets.dart';

/// Warm-tinted, four-level shadow scale.
///
/// `xs` resting cards, `sm` elevated cards, `md` popovers, `lg` sheets/modals.
/// Mirrors `--shadow-*` tokens in design_system/colors_and_type.css. Light
/// shadows tint toward the neutral-900 warm gray; dark shadows are pure
/// black at higher alpha for legibility on dim backgrounds.
@immutable
class AppShadows {
  const AppShadows._();

  static const List<BoxShadow> xsLight = <BoxShadow>[
    BoxShadow(color: Color(0x0D141413), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const List<BoxShadow> smLight = <BoxShadow>[
    BoxShadow(color: Color(0x0A141413), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0F141413), offset: Offset(0, 2), blurRadius: 6),
  ];

  static const List<BoxShadow> mdLight = <BoxShadow>[
    BoxShadow(color: Color(0x0D141413), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(color: Color(0x1A141413), offset: Offset(0, 8), blurRadius: 20),
  ];

  static const List<BoxShadow> lgLight = <BoxShadow>[
    BoxShadow(color: Color(0x0F141413), offset: Offset(0, 4), blurRadius: 8),
    BoxShadow(color: Color(0x29141413), offset: Offset(0, 18), blurRadius: 40),
  ];

  static const List<BoxShadow> xsDark = <BoxShadow>[
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
  ];

  static const List<BoxShadow> smDark = <BoxShadow>[
    BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 6),
  ];

  static const List<BoxShadow> mdDark = <BoxShadow>[
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 4),
    BoxShadow(color: Color(0x80000000), offset: Offset(0, 8), blurRadius: 20),
  ];

  static const List<BoxShadow> lgDark = <BoxShadow>[
    BoxShadow(color: Color(0x66000000), offset: Offset(0, 4), blurRadius: 8),
    BoxShadow(color: Color(0x99000000), offset: Offset(0, 18), blurRadius: 40),
  ];
}
