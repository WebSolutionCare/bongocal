import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/calendar_date.dart';
import '../entities/month_data.dart';
import '../entities/upcoming_holiday.dart';

/// Domain port for calendar conversions and month layout. Implemented by
/// [CalendarRepositoryImpl] in the data layer.
abstract class CalendarRepository {
  /// Today resolved into Gregorian, Bengali and Hijri. The implementation is
  /// expected to read "now" from an injected clock so tests can pin it.
  Future<Either<Failure, CalendarDate>> getCurrentDate();

  /// Convert any [DateTime] (interpreted as a calendar day, time-of-day
  /// ignored) into all three calendars.
  Future<Either<Failure, CalendarDate>> convertToAllCalendars(DateTime date);

  /// Build the 6×7 Sat-first grid for the given Gregorian month. The result
  /// always contains 42 cells; leading and trailing days come from the
  /// adjacent months.
  Future<Either<Failure, MonthData>> getMonthData(int year, int month);

  /// Return the next holiday or festival on or after [from] (start-of-day),
  /// or `Right(null)` when none is configured. Backed by a hard-coded BD
  /// holidays seed until the holidays feature lands.
  Future<Either<Failure, UpcomingHoliday?>> getNextHoliday(DateTime from);
}
