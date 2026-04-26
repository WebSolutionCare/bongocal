import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/month_data.dart';
import '../../domain/entities/upcoming_holiday.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/bangla_calendar_local.dart';
import '../datasources/bd_holidays_seed.dart';
import '../datasources/hijri_calendar_local.dart';
import '../models/bangla_date_model.dart';
import '../models/calendar_date_model.dart';
import '../models/hijri_date_model.dart';

/// Default repository wiring. The [now] callback is injected so tests (and
/// our pinned-date placeholder build) can pretend a specific moment is
/// "current" without faking the system clock.
class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl({
    required DateTime Function() now,
    BanglaCalendarLocal bangla = const BanglaCalendarLocal(),
    HijriCalendarLocal hijri = const HijriCalendarLocal(),
  })  : _now = now,
        _bangla = bangla,
        _hijri = hijri;

  final DateTime Function() _now;
  final BanglaCalendarLocal _bangla;
  final HijriCalendarLocal _hijri;

  @override
  Future<Either<Failure, CalendarDate>> getCurrentDate() =>
      convertToAllCalendars(_now());

  @override
  Future<Either<Failure, CalendarDate>> convertToAllCalendars(
    DateTime date,
  ) async {
    try {
      return Right<Failure, CalendarDate>(_convert(date));
    } on Exception catch (e) {
      return Left<Failure, CalendarDate>(
        CalendarFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, MonthData>> getMonthData(int year, int month) async {
    try {
      final DateTime today = _now();
      final DateTime firstOfMonth = DateTime(year, month, 1);
      final int firstWeekdaySatFirst =
          CalendarDate.satFirstIndex(firstOfMonth);

      // Sat-first leading: how many days from previous month sit before the 1st.
      final DateTime gridStart =
          firstOfMonth.subtract(Duration(days: firstWeekdaySatFirst));

      final List<CalendarDayCell> cells = <CalendarDayCell>[];
      for (int i = 0; i < 42; i++) {
        final DateTime day = DateTime(
          gridStart.year,
          gridStart.month,
          gridStart.day + i,
        );
        final CalendarDate calDate = _convert(day);
        final bool inMonth = day.month == month && day.year == year;
        final UpcomingHoliday? holiday = BdHolidaysSeed.matching(day);

        final Set<DayMark> marks = <DayMark>{
          if (_isSameDay(day, today)) DayMark.today,
          if (holiday != null && !holiday.isFestival) DayMark.holiday,
          if (holiday != null && holiday.isFestival) DayMark.festival,
        };

        cells.add(
          CalendarDayCell(
            date: calDate,
            isCurrentMonth: inMonth,
            marks: marks,
            holidayLabelBn: holiday?.nameBn,
            holidayLabelEn: holiday?.nameEn,
          ),
        );
      }

      return Right<Failure, MonthData>(
        MonthData(year: year, month: month, cells: cells),
      );
    } on Exception catch (e) {
      return Left<Failure, MonthData>(
        CalendarFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, UpcomingHoliday?>> getNextHoliday(
    DateTime from,
  ) async {
    try {
      return Right<Failure, UpcomingHoliday?>(
        BdHolidaysSeed.nextOnOrAfter(from),
      );
    } on Exception catch (e) {
      return Left<Failure, UpcomingHoliday?>(
        CalendarFailure(message: e.toString()),
      );
    }
  }

  CalendarDate _convert(DateTime date) {
    final BanglaDateModel bangla =
        BanglaDateModel.fromEntity(_bangla.convert(date));
    final HijriDateModel hijri =
        HijriDateModel.fromEntity(_hijri.convert(date));
    return CalendarDateModel.fromComputed(
      gregorian: date,
      bangla: bangla,
      hijri: hijri,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
