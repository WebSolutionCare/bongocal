import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/calendar/domain/entities/bangla_date.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/hijri_date.dart';
import 'package:bongocal/features/calendar/domain/usecases/convert_date.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_calendar_repository.dart';

void main() {
  test('forwards the input date and returns the converted value', () async {
    final CalendarDate converted = CalendarDate(
      gregorian: DateTime(2026, 4, 14),
      bangla: const BanglaDate(day: 1, monthIndex: 0, year: 1433),
      hijri: const HijriDate(day: 26, month: 9, year: 1447),
      weekdayIndexSatFirst: 3,
    );
    final FakeCalendarRepository repo = FakeCalendarRepository(
      convertResult: Right<Failure, CalendarDate>(converted),
    );
    final ConvertDate useCase = ConvertDate(repo);

    final result = await useCase(DateTime(2026, 4, 14));

    expect(repo.lastConvertedDate, DateTime(2026, 4, 14));
    expect(
      result.fold((_) => null, (CalendarDate d) => d.bangla.day),
      1,
    );
  });
}
