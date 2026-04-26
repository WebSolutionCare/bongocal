import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around Hive initialization so features can register their
/// own boxes / type adapters in one place.
///
/// Each feature owns its box names (declared as constants on [HiveBoxes]).
/// `init()` is called once from `main.dart` before `runApp`.
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  bool _initialized = false;

  /// Initialize Hive and open shared boxes. Idempotent.
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // Register feature-owned type adapters here as features come online.
    // _registerAdapters();

    // Pre-open shared boxes that are read on the home screen so the first
    // frame is not blocked on disk IO.
    await Future.wait<void>(<Future<void>>[
      Hive.openBox<dynamic>(HiveBoxes.settings),
    ]);

    _initialized = true;
  }

  /// Closes all open boxes. Call from a `dispose` hook in tests; production
  /// code rarely needs this.
  Future<void> close() async {
    if (!_initialized) return;
    await Hive.close();
    _initialized = false;
  }

  /// Convenience accessor with a typed return so callers don't have to cast.
  Box<T> box<T>(String name) => Hive.box<T>(name);
}

/// Feature-owned Hive box names. Keeping them in one constant class prevents
/// silent typos that would otherwise create a fresh empty box.
@immutable
class HiveBoxes {
  const HiveBoxes._();

  static const String settings = 'settings';
  static const String events = 'events';
  static const String holidays = 'holidays';
  static const String prayerTimes = 'prayer_times';
  static const String weather = 'weather';
  static const String notifications = 'notifications_state';
}
