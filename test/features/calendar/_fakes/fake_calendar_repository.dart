import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/calendar/domain/entities/calendar_date.dart';
import 'package:bongocal/features/calendar/domain/entities/month_data.dart';
import 'package:bongocal/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:dartz/dartz.dart';

/// Hand-rolled fake calendar repository for use-case tests.
class FakeCalendarRepository implements CalendarRepository {
  FakeCalendarRepository({
    this.todayResult,
    this.convertResult,
    this.monthResult,
  });

  Either<Failure, CalendarDate>? todayResult;
  Either<Failure, CalendarDate>? convertResult;
  Either<Failure, MonthData>? monthResult;

  DateTime? lastConvertedDate;
  ({int year, int month})? lastMonthArgs;

  @override
  Future<Either<Failure, CalendarDate>> getCurrentDate() async =>
      todayResult ?? const Left<Failure, CalendarDate>(UnknownFailure());

  @override
  Future<Either<Failure, CalendarDate>> convertToAllCalendars(
    DateTime date,
  ) async {
    lastConvertedDate = date;
    return convertResult ??
        const Left<Failure, CalendarDate>(UnknownFailure());
  }

  @override
  Future<Either<Failure, MonthData>> getMonthData(int year, int month) async {
    lastMonthArgs = (year: year, month: month);
    return monthResult ?? const Left<Failure, MonthData>(UnknownFailure());
  }
}
