import 'dart:io';

import 'package:bongocal/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:bongocal/features/settings/data/models/app_settings_model.dart';
import 'package:bongocal/features/settings/domain/entities/language_preference.dart';
import 'package:bongocal/features/settings/domain/entities/primary_calendar_preference.dart';
import 'package:bongocal/features/settings/domain/entities/theme_preference.dart';
import 'package:bongocal/features/settings/domain/entities/week_start_preference.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late SettingsLocalDataSource ds;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bongocal_settings_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(AppSettingsModelAdapter().typeId)) {
      Hive.registerAdapter(AppSettingsModelAdapter());
    }
    box = await Hive.openBox<dynamic>('settings_test_${tempDir.path.hashCode}');
    ds = SettingsLocalDataSource(box: box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  AppSettingsModel sample() => const AppSettingsModel(
        themeMode: ThemePreference.dark,
        language: LanguagePreference.english,
        primaryCalendar: PrimaryCalendarPreference.bangla,
        showBanglaNumerals: false,
        weekStartDay: WeekStartPreference.monday,
        notificationsEnabled: true,
        holidayReminderDays: <int>[1, 3, 7],
        eventReminderSound: 'chime',
        festivalGreetingsEnabled: false,
      );

  test('round-trips through Hive', () async {
    expect(ds.read(), isNull);

    final AppSettingsModel toSave = sample();
    await ds.write(toSave);

    final AppSettingsModel? loaded = ds.read();
    expect(loaded, isNotNull);
    expect(loaded!.themeMode, ThemePreference.dark);
    expect(loaded.language, LanguagePreference.english);
    expect(loaded.holidayReminderDays, <int>[1, 3, 7]);
    expect(loaded.eventReminderSound, 'chime');
  });

  test('watch emits on subsequent writes', () async {
    final AppSettingsModel toSave = sample();
    final List<AppSettingsModel?> events = <AppSettingsModel?>[];
    final sub = ds.watch().listen(events.add);

    await ds.write(toSave);
    await Future<void>.delayed(const Duration(milliseconds: 30));

    await sub.cancel();
    expect(events.length, greaterThanOrEqualTo(1));
    expect(events.first?.themeMode, ThemePreference.dark);
  });
}
