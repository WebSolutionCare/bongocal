import 'package:bongocal/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/month_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CalendarRepositoryImpl repo() => CalendarRepositoryImpl(
        now: () => DateTime(2026, 4, 27),
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
      final result = await repo().getMonthData(2026, 4);
      result.fold(
        (_) => fail('expected Right'),
        (MonthData m) {
          expect(m.cells.length, 42);

          // First cell sits at Sat-first column 0 of the week containing
          // April 1, 2026 (Wednesday). April 1 is Sat-first index 4, so
          // grid starts on March 28, 2026 (Saturday).
          expect(m.cells.first.date.gregorian, DateTime(2026, 3, 28));
          expect(m.cells.first.date.weekdayIndexSatFirst, 0);

          // Today (April 27) must be flagged.
          final CalendarDayCell? today =
              m.cellFor(DateTime(2026, 4, 27));
          expect(today, isNotNull);
          expect(today!.isToday, isTrue);

          // Pohela Boishakh (April 14) must be flagged as a festival.
          final CalendarDayCell? boishakh =
              m.cellFor(DateTime(2026, 4, 14));
          expect(boishakh, isNotNull);
          expect(boishakh!.isFestival, isTrue);

          // April 30 sits inside the month.
          expect(m.cellFor(DateTime(2026, 4, 30))!.isCurrentMonth, isTrue);

          // March 28 sits outside the displayed month.
          expect(m.cells.first.isCurrentMonth, isFalse);
        },
      );
    });
  });

  group('getNextHoliday', () {
    test('returns May 1 (May Day) as next holiday from April 27', () async {
      final result = await repo().getNextHoliday(DateTime(2026, 4, 27));
      result.fold(
        (_) => fail('expected Right'),
        (h) {
          expect(h, isNotNull);
          expect(h!.id, 'may_day');
          expect(h.daysAway, 4);
        },
      );
    });
  });
}
