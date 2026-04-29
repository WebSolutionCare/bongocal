import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Cross-feature clock. Every feature that asks for "now" reads it from
/// here so a single override (e.g. in tests) flows through the whole app.
///
/// Production: real time. Tests override via `ProviderScope.overrides`.
DateTime _defaultNow() => DateTime.now();

final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((Ref ref) => _defaultNow);
