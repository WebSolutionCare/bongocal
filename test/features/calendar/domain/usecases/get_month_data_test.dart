import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/calendar/domain/entities/bangla_date.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/hijri_date.dart';
import 'package:bongocal/features/calendar/domain/entities/month_data.dart';
import 'package:bongocal/features/calendar/domain/usecases/get_month_data.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_calendar_repository.dart';

void main() {
  CalendarDayCell stubCell(int i) => CalendarDayCell(
        date: CalendarDate(
          gregorian: DateTime(2026, 4, 1).add(Duration(days: i)),
          bangla: const BanglaDate(day: 1, monthIndex: 0, year: 1433),
          hijri: const HijriDate(day: 1, month: 10, year: 1447),
          weekdayIndexSatFirst: i % 7,
        ),
        isCurrentMonth: true,
      );

  test('forwards year+month and returns the grid', () async {
    final MonthData data = MonthData(
      year: 2026,
      month: 4,
      cells: List<CalendarDayCell>.generate(42, stubCell),
    );
    final FakeCalendarRepository repo = FakeCalendarRepository(
      monthResult: Right<Failure, MonthData>(data),
    );
    final GetMonthData useCase = GetMonthData(repo);

    final result = await useCase(
      const GetMonthDataParams(year: 2026, month: 4),
    );

    expect(repo.lastMonthArgs, (year: 2026, month: 4));
    expect(
      result.fold((_) => null, (MonthData d) => d.cells.length),
      42,
    );
  });

  test('GetMonthDataParams rejects invalid months', () {
    expect(() => GetMonthDataParams(year: 2026, month: 0), throwsAssertionError);
    expect(() => GetMonthDataParams(year: 2026, month: 13), throwsAssertionError);
  });
}
