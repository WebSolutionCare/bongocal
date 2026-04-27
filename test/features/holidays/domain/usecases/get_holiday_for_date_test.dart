import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/usecases/get_holiday_for_date.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_holiday_repository.dart';

void main() {
  final FakeHolidayRepository repo = FakeHolidayRepository(
    holidays: <Holiday>[
      makeHoliday(id: 'boishakh', date: DateTime(2026, 4, 14)),
    ],
  );

  test('returns the holiday landing on the requested day', () async {
    final result =
        await GetHolidayForDate(repo)(DateTime(2026, 4, 14, 23, 59));
    final Holiday? holiday =
        result.fold((_) => fail('expected Right'), (Holiday? h) => h);
    expect(holiday?.id, 'boishakh');
  });

  test('returns null when no holiday lands on the requested day', () async {
    final result = await GetHolidayForDate(repo)(DateTime(2026, 4, 27));
    final Holiday? holiday =
        result.fold((_) => fail('expected Right'), (Holiday? h) => h);
    expect(holiday, isNull);
  });
}
