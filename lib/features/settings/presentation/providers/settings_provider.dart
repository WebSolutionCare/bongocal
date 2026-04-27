import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_service.dart';
import '../../../../core/utils/bangla_numerals.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/language_preference.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';

/// Hive box backing settings — opened lazily by [HiveService] at startup.
final Provider<Box<dynamic>> settingsBoxProvider = Provider<Box<dynamic>>(
  (Ref ref) => Hive.box<dynamic>(HiveBoxes.settings),
);

final Provider<SettingsLocalDataSource> settingsLocalDataSourceProvider =
    Provider<SettingsLocalDataSource>(
  (Ref ref) => SettingsLocalDataSource(box: ref.watch(settingsBoxProvider)),
);

final Provider<SettingsRepository> settingsRepositoryProvider =
    Provider<SettingsRepository>(
  (Ref ref) => SettingsRepositoryImpl(
    dataSource: ref.watch(settingsLocalDataSourceProvider),
  ),
);

/// Reactive stream of the persisted settings. The first event is the
/// already-stored value (or [AppSettings.defaults]).
final StreamProvider<AppSettings> settingsProvider =
    StreamProvider<AppSettings>(
  (Ref ref) => ref.watch(settingsRepositoryProvider).watchSettings(),
);

/// Synchronous convenience: reads settings or falls back to defaults during
/// the initial frame before the stream emits.
final Provider<AppSettings> currentSettingsProvider = Provider<AppSettings>(
  (Ref ref) =>
      ref.watch(settingsProvider).valueOrNull ?? AppSettings.defaults(),
);

/// Material-friendly theme mode derived from [settingsProvider].
final Provider<ThemeMode> themeModeProvider = Provider<ThemeMode>((Ref ref) {
  final ThemePreference pref =
      ref.watch(currentSettingsProvider).themeMode;
  switch (pref) {
    case ThemePreference.light:
      return ThemeMode.light;
    case ThemePreference.dark:
      return ThemeMode.dark;
    case ThemePreference.system:
      return ThemeMode.system;
  }
});

/// Material locale derived from [settingsProvider].
final Provider<Locale> localeProvider = Provider<Locale>((Ref ref) {
  final LanguagePreference pref = ref.watch(currentSettingsProvider).language;
  return Locale(pref.languageCode, pref.countryCode);
});

/// True when number-rendering helpers should use Bangla numerals.
final Provider<bool> useBanglaNumeralsProvider = Provider<bool>(
  (Ref ref) => ref.watch(currentSettingsProvider).showBanglaNumerals,
);

/// `int -> String` formatter that respects [useBanglaNumeralsProvider].
/// Widgets read this once with `ref.watch` and call the closure for each
/// number they render.
final Provider<String Function(int)> numeralFormatterProvider =
    Provider<String Function(int)>((Ref ref) {
  final bool bangla = ref.watch(useBanglaNumeralsProvider);
  return bangla ? BanglaNumerals.fromInt : (int n) => n.toString();
});
