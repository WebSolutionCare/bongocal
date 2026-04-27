import 'package:bongocal/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/month_data.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../holidays/_fakes/fake_holiday_repository.dart';

void main() {
  CalendarRepositoryImpl repo({FakeHolidayRepository? holidays}) =>
      CalendarRepositoryImpl(
        now: () => DateTime(2026, 4, 27),
        holidayRepository: holidays ?? FakeHolidayRepository(),
      );

  group('getCurrentDate', () {
    test('returns CalendarDate pinned to the injected clock', () async {
      final result = await repo().getCurrentDate();
      result.fold(
        (_) => fail('expected Right'),
        (CalendarDate d) {
          expect(d.gregorian, DateTime(2026, 4, 27));
          expect(d.bangla.day, 14);
          expect(d.bangla.monthIndex, 0);
          expect(d.bangla.year, 1433);
          // April 27, 2026 = Monday → Sat-first index 2.
          expect(d.weekdayIndexSatFirst, 2);
        },
      );
    });
  });

  group('getMonthData', () {
    test('returns 42 cells, Sat-first, with current-month flag set', () async {
      final FakeHolidayRepository holidays = FakeHolidayRepository(
        holidays: <Holiday>[
          makeHoliday(
            id: 'pohela_boishakh',
            date: DateTime(2026, 4, 14),
            type: HolidayType.religious,
          ),
        ],
      );
      final result = await repo(holidays: holidays).getMonthData(2026, 4);
      result.fold(
        (_) => fail('expected Right'),
        (MonthData m) {
          expect(m.cells.length, 42);

          // First cell sits at Sat-first column 0 of the week containing
          // April 1, 2026 (Wed = Sat-first index 4 → grid starts March 28).
          expect(m.cells.first.date.gregorian, DateTime(2026, 3, 28));
          expect(m.cells.first.date.weekdayIndexSatFirst, 0);

          // Today (April 27) must be flagged.
          final CalendarDayCell? today =
              m.cellFor(DateTime(2026, 4, 27));
          expect(today, isNotNull);
          expect(today!.isToday, isTrue);

          // Pohela Boishakh (April 14) flagged as festival via the holiday
          // repo (religious type).
          final CalendarDayCell? boishakh =
              m.cellFor(DateTime(2026, 4, 14));
          expect(boishakh, isNotNull);
          expect(boishakh!.isFestival, isTrue);

          expect(m.cellFor(DateTime(2026, 4, 30))!.isCurrentMonth, isTrue);
          expect(m.cells.first.isCurrentMonth, isFalse);
        },
      );
    });
  });
}
