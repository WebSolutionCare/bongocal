import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/notifications/domain/usecases/schedule_holiday_reminders.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_notification_scheduler.dart';
import '../../_fakes/holiday_fixtures.dart';

void main() {
  test('ScheduleHolidayReminders forwards holidays + settings unchanged',
      () async {
    final FakeNotificationScheduler scheduler = FakeNotificationScheduler();
    final ScheduleHolidayReminders usecase = ScheduleHolidayReminders(scheduler);

    final List<Holiday> holidays = <Holiday>[
      testHoliday(id: 'h1', date: DateTime(2026, 5, 1)),
      testHoliday(id: 'h2', date: DateTime(2026, 7, 4)),
    ];
    final AppSettings settings = AppSettings.defaults();

    final result = await usecase(holidays: holidays, settings: settings);

    expect(result.isRight(), isTrue);
    expect(scheduler.scheduleCount, 1);
    expect(
      scheduler.lastHolidays?.map((Holiday h) => h.id).toList(),
      <String>['h1', 'h2'],
    );
    expect(scheduler.lastSettings, settings);
  });
}
