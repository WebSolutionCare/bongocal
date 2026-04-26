import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/calendar/domain/entities/bangla_date.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/hijri_date.dart';
import 'package:bongocal/features/calendar/domain/usecases/get_today.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_calendar_repository.dart';

void main() {
  CalendarDate fixture() => CalendarDate(
        gregorian: DateTime(2026, 4, 27),
        bangla: const BanglaDate(day: 14, monthIndex: 0, year: 1433),
        hijri: const HijriDate(day: 9, month: 10, year: 1447),
        weekdayIndexSatFirst: 2,
      );

  test('returns today from the repository', () async {
    final FakeCalendarRepository repo = FakeCalendarRepository(
      todayResult: Right<Failure, CalendarDate>(fixture()),
    );
    final GetToday useCase = GetToday(repo);

    final result = await useCase();

    expect(
      result.fold((_) => null, (CalendarDate d) => d.gregorian),
      DateTime(2026, 4, 27),
    );
  });

  test('propagates a repository failure', () async {
    final FakeCalendarRepository repo = FakeCalendarRepository(
      todayResult:
          const Left<Failure, CalendarDate>(CalendarFailure(message: 'boom')),
    );
    final GetToday useCase = GetToday(repo);

    final result = await useCase();

    expect(result.isLeft(), isTrue);
    result.fold(
      (Failure f) => expect(f, isA<CalendarFailure>()),
      (_) => fail('expected Left'),
    );
  });
}
