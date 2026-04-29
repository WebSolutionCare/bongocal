import 'package:hive/hive.dart';

/// Tiny key/value façade over the existing Hive `settings` box. The
/// settings feature stores its big `AppSettingsModel` under key
/// `'app_settings'`; this datasource uses a separate key so the two
/// coexist in the same box.
class OnboardingLocalDataSource {
  OnboardingLocalDataSource({required Box<dynamic> box}) : _box = box;

  static const String _key = 'onboarding_completed';

  final Box<dynamic> _box;

  bool readCompleted() => (_box.get(_key) as bool?) ?? false;

  Future<void> writeCompleted(bool value) => _box.put(_key, value);
}
