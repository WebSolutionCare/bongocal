import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/notifications/domain/usecases/reschedule_on_settings_change.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_notification_scheduler.dart';
import '../../_fakes/holiday_fixtures.dart';

void main() {
  group('RescheduleOnSettingsChange', () {
    late FakeNotificationScheduler scheduler;
    late RescheduleOnSettingsChange usecase;

    setUp(() {
      scheduler = FakeNotificationScheduler();
      usecase = RescheduleOnSettingsChange(scheduler);
    });

    test('schedules when notifications are enabled and days are picked',
        () async {
      final AppSettings settings = AppSettings.defaults().copyWith(
        notificationsEnabled: true,
        holidayReminderDays: <int>[1, 3],
      );

      await usecase(
        holidays: <Holiday>[
          testHoliday(id: 'eid-fitr', date: DateTime(2026, 5, 21)),
        ],
        settings: settings,
      );

      expect(scheduler.scheduleCount, 1);
      expect(scheduler.cancelAllCount, 0);
      expect(scheduler.lastSettings?.holidayReminderDays, <int>[1, 3]);
    });

    test('cancels when reminders are toggled off', () async {
      final AppSettings settings = AppSettings.defaults().copyWith(
        notificationsEnabled: false,
        holidayReminderDays: <int>[3],
      );

      await usecase(
        holidays: <Holiday>[
          testHoliday(id: 'pohela-boishakh', date: DateTime(2026, 4, 14)),
        ],
        settings: settings,
      );

      expect(scheduler.cancelAllCount, 1);
      expect(scheduler.scheduleCount, 0);
    });

    test('cancels when no days are selected (empty list)', () async {
      final AppSettings settings = AppSettings.defaults().copyWith(
        notificationsEnabled: true,
        holidayReminderDays: const <int>[],
      );

      await usecase(holidays: const <Holiday>[], settings: settings);

      expect(scheduler.cancelAllCount, 1);
      expect(scheduler.scheduleCount, 0);
    });
  });
}
