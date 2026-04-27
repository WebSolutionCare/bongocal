import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/usecases/get_holidays_for_year.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_holiday_repository.dart';

void main() {
  test('returns only the requested year, sorted ascending', () async {
    final FakeHolidayRepository repo = FakeHolidayRepository(
      holidays: <Holiday>[
        makeHoliday(id: 'a', date: DateTime(2025, 12, 31)),
        makeHoliday(id: 'b', date: DateTime(2026, 4, 14)),
        makeHoliday(id: 'c', date: DateTime(2026, 1, 1)),
        makeHoliday(id: 'd', date: DateTime(2027, 1, 1)),
      ],
    );

    final result = await GetHolidaysForYear(repo)(2026);

    final List<Holiday> list =
        result.fold((_) => fail('expected Right'), (List<Holiday> l) => l);
    expect(list.map((Holiday h) => h.id), <String>['c', 'b']);
  });
}
