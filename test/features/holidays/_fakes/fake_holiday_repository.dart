import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday_type.dart';
import 'package:bongocal/features/holidays/domain/repositories/holiday_repository.dart';
import 'package:dartz/dartz.dart';

/// Hand-rolled fake repository for unit-testing use cases without a mocking
/// framework. The data set is configurable per test.
class FakeHolidayRepository implements HolidayRepository {
  FakeHolidayRepository({this.holidays = const <Holiday>[]});

  List<Holiday> holidays;

  @override
  Future<Either<Failure, List<Holiday>>> getAllHolidays(int year) async {
    final List<Holiday> filtered = <Holiday>[
      for (final Holiday h in holidays)
        if (h.date.year == year) h,
    ]..sort((Holiday a, Holiday b) => a.date.compareTo(b.date));
    return Right<Failure, List<Holiday>>(filtered);
  }

  @override
  Future<Either<Failure, Holiday?>> getHolidayByDate(DateTime date) async {
    for (final Holiday h in holidays) {
      if (h.date.year == date.year &&
          h.date.month == date.month &&
          h.date.day == date.day) {
        return Right<Failure, Holiday?>(h);
      }
    }
    return const Right<Failure, Holiday?>(null);
  }

  @override
  Future<Either<Failure, List<Holiday>>> getUpcomingHolidays({
    required DateTime from,
    int? limit,
  }) async {
    final DateTime cutoff = DateTime(from.year, from.month, from.day);
    final List<Holiday> upcoming = <Holiday>[
      for (final Holiday h in holidays)
        if (!h.date.isBefore(cutoff)) h,
    ]..sort((Holiday a, Holiday b) => a.date.compareTo(b.date));
    return Right<Failure, List<Holiday>>(
      limit == null || limit >= upcoming.length
          ? upcoming
          : upcoming.sublist(0, limit),
    );
  }

  @override
  Future<Either<Failure, List<Holiday>>> getHolidaysByType(
    HolidayType type, {
    required int year,
  }) async {
    final List<Holiday> filtered = <Holiday>[
      for (final Holiday h in holidays)
        if (h.type == type && h.date.year == year) h,
    ];
    return Right<Failure, List<Holiday>>(filtered);
  }

  @override
  Future<Either<Failure, Holiday?>> getHolidayById(String id) async {
    for (final Holiday h in holidays) {
      if (h.id == id) return Right<Failure, Holiday?>(h);
    }
    return const Right<Failure, Holiday?>(null);
  }
}

/// Convenience constructor for tests — keeps test files terse.
Holiday makeHoliday({
  required DateTime date,
  String id = 'h',
  String nameBn = 'নাম',
  String nameEn = 'Name',
  HolidayType type = HolidayType.governmentNational,
  bool isGovernmentHoliday = true,
  bool banksClosed = true,
  bool isObservance = false,
}) =>
    Holiday(
      id: id,
      nameBn: nameBn,
      nameEn: nameEn,
      date: date,
      type: type,
      descriptionBn: '',
      descriptionEn: '',
      isGovernmentHoliday: isGovernmentHoliday,
      banksClosed: banksClosed,
      isObservance: isObservance,
    );
