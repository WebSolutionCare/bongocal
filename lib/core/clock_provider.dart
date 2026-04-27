import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pinned "today" so the placeholder build matches the design references.
///
/// Replace with `DateTime.now` once onboarding lands. Tests override the
/// provider directly via `ProviderScope.overrides`.
DateTime _defaultNow() => DateTime(2026, 4, 27);

/// Cross-feature clock. Every feature that asks for "now" reads it from
/// here so a single override (e.g. in tests) flows through the whole app.
final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((Ref ref) => _defaultNow);
