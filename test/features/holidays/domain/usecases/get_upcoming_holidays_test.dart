import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/usecases/get_upcoming_holidays.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_holiday_repository.dart';

void main() {
  final FakeHolidayRepository repo = FakeHolidayRepository(
    holidays: <Holiday>[
      makeHoliday(id: 'past', date: DateTime(2026, 3, 26)),
      makeHoliday(id: 'today', date: DateTime(2026, 4, 27)),
      makeHoliday(id: 'next1', date: DateTime(2026, 5, 1)),
      makeHoliday(id: 'next2', date: DateTime(2026, 5, 28)),
    ],
  );

  test('skips past holidays, includes today, sorts ascending', () async {
    final result = await GetUpcomingHolidays(repo)(
      GetUpcomingHolidaysParams(from: DateTime(2026, 4, 27)),
    );

    final List<Holiday> list =
        result.fold((_) => fail('expected Right'), (List<Holiday> l) => l);
    expect(list.map((Holiday h) => h.id), <String>['today', 'next1', 'next2']);
  });

  test('honors limit', () async {
    final result = await GetUpcomingHolidays(repo)(
      GetUpcomingHolidaysParams(from: DateTime(2026, 4, 27), limit: 2),
    );

    final List<Holiday> list =
        result.fold((_) => fail('expected Right'), (List<Holiday> l) => l);
    expect(list.length, 2);
    expect(list.first.id, 'today');
  });
}
