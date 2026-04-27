import 'package:hive/hive.dart';

import '../models/app_settings_model.dart';

/// Hive-backed read/write/watch for the singleton [AppSettingsModel].
/// All ops route through a single record at [_singletonKey]; the box may
/// hold other keys later (e.g. onboarding flags) without conflict.
class SettingsLocalDataSource {
  SettingsLocalDataSource({required Box<dynamic> box}) : _box = box;

  static const String _singletonKey = 'app_settings';

  final Box<dynamic> _box;

  AppSettingsModel? read() {
    final dynamic raw = _box.get(_singletonKey);
    if (raw is AppSettingsModel) return raw;
    return null;
  }

  Future<void> write(AppSettingsModel settings) =>
      _box.put(_singletonKey, settings);

  /// Stream emits whenever the singleton record is updated. The caller is
  /// expected to seed the first frame from [read]; this watcher fires only
  /// on subsequent writes.
  Stream<AppSettingsModel?> watch() => _box.watch(key: _singletonKey).map(
        (BoxEvent event) =>
            event.deleted ? null : event.value as AppSettingsModel?,
      );
}
