import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/events/data/models/personal_event_model.dart';
import '../../features/settings/data/models/app_settings_model.dart';

/// Thin wrapper around Hive initialization so features can register their
/// own boxes / type adapters in one place.
///
/// Each feature owns its box names (declared as constants on [HiveBoxes]).
/// `init()` is called once from `main.dart` before `runApp`.
class HiveService {
  HiveService._();

  static final HiveService instance = HiveService._();

  bool _initialized = false;

  /// Initialize Hive, register feature type adapters, and pre-open boxes
  /// the home screen reads on first frame. Idempotent.
  Future<void> init() async {
    if (_initialized) return;

    await Hive.initFlutter();

    // === Type adapters ===
    if (!Hive.isAdapterRegistered(PersonalEventModelAdapter().typeId)) {
      Hive.registerAdapter(PersonalEventModelAdapter());
    }
    if (!Hive.isAdapterRegistered(AppSettingsModelAdapter().typeId)) {
      Hive.registerAdapter(AppSettingsModelAdapter());
    }

    // === Pre-open boxes ===
    await Future.wait<void>(<Future<void>>[
      Hive.openBox<dynamic>(HiveBoxes.settings),
      Hive.openBox<PersonalEventModel>(HiveBoxes.events),
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
