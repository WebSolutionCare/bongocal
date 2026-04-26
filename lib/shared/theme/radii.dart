import 'package:flutter/widgets.dart';

/// Corner radii from design system.
///
/// `xs` chips, `sm` inputs, `md` cards, `lg` sheets, `xl` modals,
/// `pill` for pills/avatars (effectively a circle on small surfaces).
@immutable
class AppRadii {
  const AppRadii._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double pill = 999;

  static const Radius xsRadius = Radius.circular(xs);
  static const Radius smRadius = Radius.circular(sm);
  static const Radius mdRadius = Radius.circular(md);
  static const Radius lgRadius = Radius.circular(lg);
  static const Radius xlRadius = Radius.circular(xl);
  static const Radius pillRadius = Radius.circular(pill);

  static const BorderRadius xsBorder = BorderRadius.all(xsRadius);
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const BorderRadius mdBorder = BorderRadius.all(mdRadius);
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const BorderRadius xlBorder = BorderRadius.all(xlRadius);
  static const BorderRadius pillBorder = BorderRadius.all(pillRadius);
}
