import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/holiday.dart';
import '../entities/holiday_type.dart';

/// Domain port for holiday lookup. The data layer's [HolidayLocalDataSource]
/// loads `assets/data/holidays_<year>.json` and caches the parsed list; all
/// queries below are O(n) over that cache.
abstract class HolidayRepository {
  /// All holidays in [year], sorted ascending by date.
  Future<Either<Failure, List<Holiday>>> getAllHolidays(int year);

  /// Holiday landing on [date] (any year). `Right(null)` when nothing
  /// matches — the calendar feature uses this for cell-marking.
  Future<Either<Failure, Holiday?>> getHolidayByDate(DateTime date);

  /// Upcoming holidays on or after [from], sorted ascending by date. If
  /// [limit] is null, returns all remaining holidays in the same year.
  Future<Either<Failure, List<Holiday>>> getUpcomingHolidays({
    required DateTime from,
    int? limit,
  });

  /// All holidays of [type] in [year], sorted ascending.
  Future<Either<Failure, List<Holiday>>> getHolidaysByType(
    HolidayType type, {
    required int year,
  });

  /// Single holiday by stable id (used by `/holidays/:id`).
  Future<Either<Failure, Holiday?>> getHolidayById(String id);
}
