import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday_type.dart';
import 'package:bongocal/features/holidays/domain/usecases/filter_holidays_by_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_holiday_repository.dart';

void main() {
  final FakeHolidayRepository repo = FakeHolidayRepository(
    holidays: <Holiday>[
      makeHoliday(
        id: 'eid',
        type: HolidayType.religious,
        date: DateTime(2026, 5, 28),
      ),
      makeHoliday(
        id: 'mayday',
        type: HolidayType.international,
        date: DateTime(2026, 5, 1),
      ),
      makeHoliday(
        id: 'victory',
        type: HolidayType.governmentNational,
        date: DateTime(2026, 12, 16),
      ),
    ],
  );

  test('returns only entries matching the requested type and year', () async {
    final result = await FilterHolidaysByType(repo)(
      const FilterHolidaysByTypeParams(
        type: HolidayType.religious,
        year: 2026,
      ),
    );

    final List<Holiday> list =
        result.fold((_) => fail('expected Right'), (List<Holiday> l) => l);
    expect(list.map((Holiday h) => h.id), <String>['eid']);
  });
}
