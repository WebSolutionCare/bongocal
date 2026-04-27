import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:bongocal/features/settings/domain/entities/language_preference.dart';
import 'package:bongocal/features/settings/domain/entities/primary_calendar_preference.dart';
import 'package:bongocal/features/settings/domain/entities/theme_preference.dart';
import 'package:bongocal/features/settings/domain/entities/week_start_preference.dart';
import 'package:bongocal/features/settings/domain/usecases/get_settings.dart';
import 'package:bongocal/features/settings/domain/usecases/reset_to_defaults.dart';
import 'package:bongocal/features/settings/domain/usecases/update_calendar_preference.dart';
import 'package:bongocal/features/settings/domain/usecases/update_language.dart';
import 'package:bongocal/features/settings/domain/usecases/update_notification_settings.dart';
import 'package:bongocal/features/settings/domain/usecases/update_theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_settings_repository.dart';

void main() {
  test('GetSettings returns the persisted record', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    final result = await GetSettings(repo)();
    final AppSettings? s = result.fold((_) => null, (AppSettings s) => s);
    expect(s, AppSettings.defaults());
  });

  test('UpdateTheme flips themeMode without disturbing other fields', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    await UpdateTheme(repo)(ThemePreference.dark);
    expect(repo.currentForTest.themeMode, ThemePreference.dark);
    expect(repo.currentForTest.language, LanguagePreference.bangla);
  });

  test('UpdateLanguage persists', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    await UpdateLanguage(repo)(LanguagePreference.english);
    expect(repo.currentForTest.language, LanguagePreference.english);
  });

  test('UpdateCalendarPreference applies named fields independently',
      () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    await UpdateCalendarPreference(repo)(
      primary: PrimaryCalendarPreference.bangla,
      weekStart: WeekStartPreference.monday,
    );
    expect(
      repo.currentForTest.primaryCalendar,
      PrimaryCalendarPreference.bangla,
    );
    expect(repo.currentForTest.weekStartDay, WeekStartPreference.monday);
    expect(
      repo.currentForTest.showBanglaNumerals,
      true,
      reason: 'untouched fields keep their previous value',
    );
  });

  test('UpdateNotificationSettings persists holidayReminderDays', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository();
    await UpdateNotificationSettings(repo)(
      holidayReminderDays: <int>[1, 3, 7],
      festivalGreetingsEnabled: false,
    );
    expect(repo.currentForTest.holidayReminderDays, <int>[1, 3, 7]);
    expect(repo.currentForTest.festivalGreetingsEnabled, false);
  });

  test('ResetToDefaults restores the canonical defaults', () async {
    final FakeSettingsRepository repo = FakeSettingsRepository(
      initial: AppSettings.defaults().copyWith(
        themeMode: ThemePreference.dark,
        showBanglaNumerals: false,
      ),
    );
    await ResetToDefaults(repo)();
    expect(repo.currentForTest, AppSettings.defaults());
  });
}
