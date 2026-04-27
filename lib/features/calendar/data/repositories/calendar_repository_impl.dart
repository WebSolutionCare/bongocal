import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../events/domain/entities/personal_event.dart';
import '../../../events/domain/repositories/event_repository.dart';
import '../../../holidays/domain/entities/holiday.dart';
import '../../../holidays/domain/repositories/holiday_repository.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/month_data.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../datasources/bangla_calendar_local.dart';
import '../datasources/hijri_calendar_local.dart';
import '../models/bangla_date_model.dart';
import '../models/calendar_date_model.dart';
import '../models/hijri_date_model.dart';

/// Default calendar repository wiring.
///
/// Holiday cell-marks come from the holidays feature via [HolidayRepository] —
/// calendar.data depends on holidays.domain (a port + entity), not on the
/// holidays implementation. This is a controlled cross-feature seam: one-way
/// (calendar → holidays.domain), no symbol from holidays leaks back.
class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl({
    required DateTime Function() now,
    required HolidayRepository holidayRepository,
    EventRepository? eventRepository,
    BanglaCalendarLocal bangla = const BanglaCalendarLocal(),
    HijriCalendarLocal hijri = const HijriCalendarLocal(),
  })  : _now = now,
        _holidayRepository = holidayRepository,
        _eventRepository = eventRepository,
        _bangla = bangla,
        _hijri = hijri;

  final DateTime Function() _now;
  final HolidayRepository _holidayRepository;

  /// Optional — when supplied, the month grid tags any cell with a personal
  /// event using [DayMark.event].
  final EventRepository? _eventRepository;
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

      final DateTime gridStart =
          firstOfMonth.subtract(Duration(days: firstWeekdaySatFirst));
      final DateTime gridEnd = gridStart.add(const Duration(days: 41));

      // Pull holidays for every year the grid touches (the prev/next month
      // edges may straddle a year boundary).
      final Map<DateTime, Holiday> holidayLookup = await _loadHolidayLookup(
        startYear: gridStart.year,
        endYear: gridEnd.year,
      );

      final Set<DateTime> eventDays =
          await _loadEventDays(start: gridStart, end: gridEnd);

      final List<CalendarDayCell> cells = <CalendarDayCell>[];
      for (int i = 0; i < 42; i++) {
        final DateTime day = DateTime(
          gridStart.year,
          gridStart.month,
          gridStart.day + i,
        );
        final CalendarDate calDate = _convert(day);
        final bool inMonth = day.month == month && day.year == year;
        final Holiday? holiday = holidayLookup[_dayKey(day)];
        final bool hasEvent = eventDays.contains(_dayKey(day));

        final Set<DayMark> marks = <DayMark>{
          if (_isSameDay(day, today)) DayMark.today,
          if (holiday != null && !holiday.isFestival) DayMark.holiday,
          if (holiday != null && holiday.isFestival) DayMark.festival,
          if (hasEvent) DayMark.event,
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

  Future<Set<DateTime>> _loadEventDays({
    required DateTime start,
    required DateTime end,
  }) async {
    final EventRepository? repo = _eventRepository;
    if (repo == null) return const <DateTime>{};

    // Pull every month the grid spans (typically 1 or 2 months).
    final Set<DateTime> days = <DateTime>{};
    final Set<({int year, int month})> months = <({int year, int month})>{};
    DateTime probe = DateTime(start.year, start.month);
    final DateTime endMonth = DateTime(end.year, end.month);
    while (!probe.isAfter(endMonth)) {
      months.add((year: probe.year, month: probe.month));
      probe = DateTime(probe.year, probe.month + 1);
    }
    for (final ({int year, int month}) m in months) {
      final result = await repo.getEventsForMonth(m.year, m.month);
      result.fold(
        (_) => null,
        (List<PersonalEvent> events) {
          for (final PersonalEvent e in events) {
            DateTime probe = start;
            while (!probe.isAfter(end)) {
              if (e.occursOn(probe)) days.add(_dayKey(probe));
              probe = probe.add(const Duration(days: 1));
            }
          }
        },
      );
    }
    return days;
  }

  Future<Map<DateTime, Holiday>> _loadHolidayLookup({
    required int startYear,
    required int endYear,
  }) async {
    final Map<DateTime, Holiday> lookup = <DateTime, Holiday>{};
    for (int y = startYear; y <= endYear; y++) {
      final result = await _holidayRepository.getAllHolidays(y);
      result.fold(
        (_) => null, // missing year file → no marks for that year
        (List<Holiday> holidays) {
          for (final Holiday h in holidays) {
            lookup[_dayKey(h.date)] = h;
          }
        },
      );
    }
    return lookup;
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

  static DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
