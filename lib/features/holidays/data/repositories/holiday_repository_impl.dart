import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../datasources/holiday_local_datasource.dart';
import '../models/holiday_model.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  HolidayRepositoryImpl({required HolidayLocalDataSource dataSource})
      : _dataSource = dataSource;

  final HolidayLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<Holiday>>> getAllHolidays(int year) async {
    try {
      final List<HolidayModel> all = await _dataSource.loadAll(year);
      return Right<Failure, List<Holiday>>(List<Holiday>.unmodifiable(all));
    } on CacheException catch (e) {
      return Left<Failure, List<Holiday>>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Holiday?>> getHolidayByDate(DateTime date) async {
    try {
      final List<HolidayModel> all = await _dataSource.loadAll(date.year);
      for (final HolidayModel h in all) {
        if (h.date.year == date.year &&
            h.date.month == date.month &&
            h.date.day == date.day) {
          return Right<Failure, Holiday?>(h);
        }
      }
      return const Right<Failure, Holiday?>(null);
    } on CacheException catch (e) {
      return Left<Failure, Holiday?>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Holiday>>> getUpcomingHolidays({
    required DateTime from,
    int? limit,
  }) async {
    try {
      final DateTime cutoff = DateTime(from.year, from.month, from.day);
      final List<HolidayModel> all = await _dataSource.loadAll(cutoff.year);
      final List<Holiday> upcoming = <Holiday>[
        for (final HolidayModel h in all)
          if (!h.date.isBefore(cutoff)) h,
      ];
      final List<Holiday> result = limit == null || limit >= upcoming.length
          ? upcoming
          : upcoming.sublist(0, limit);
      return Right<Failure, List<Holiday>>(List<Holiday>.unmodifiable(result));
    } on CacheException catch (e) {
      return Left<Failure, List<Holiday>>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Holiday>>> getHolidaysByType(
    HolidayType type, {
    required int year,
  }) async {
    try {
      final List<HolidayModel> all = await _dataSource.loadAll(year);
      final List<Holiday> filtered = <Holiday>[
        for (final HolidayModel h in all)
          if (h.type == type) h,
      ];
      return Right<Failure, List<Holiday>>(List<Holiday>.unmodifiable(filtered));
    } on CacheException catch (e) {
      return Left<Failure, List<Holiday>>(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Holiday?>> getHolidayById(String id) async {
    // We do not know the year up front, so try the current calendar year
    // first, then fall back to the next/previous year.
    final int now = DateTime.now().year;
    for (final int year in <int>[now, now + 1, now - 1]) {
      try {
        final List<HolidayModel> all = await _dataSource.loadAll(year);
        for (final HolidayModel h in all) {
          if (h.id == id) return Right<Failure, Holiday?>(h);
        }
      } on CacheException {
        // Year not seeded — try the next candidate.
        continue;
      }
    }
    return const Right<Failure, Holiday?>(null);
  }
}
