import 'package:equatable/equatable.dart';

import 'calendar_date.dart';

/// Marks attached to a calendar cell. A single cell can carry multiple marks
/// (e.g. a holiday with a personal event).
enum DayMark { today, holiday, festival, event }

class CalendarDayCell extends Equatable {
  const CalendarDayCell({
    required this.date,
    required this.isCurrentMonth,
    this.marks = const <DayMark>{},
    this.holidayLabelBn,
    this.holidayLabelEn,
  });

  final CalendarDate date;
  final bool isCurrentMonth;
  final Set<DayMark> marks;

  /// Human-readable holiday label (e.g. `পহেলা বৈশাখ`). Null on regular days.
  final String? holidayLabelBn;
  final String? holidayLabelEn;

  bool get isToday => marks.contains(DayMark.today);
  bool get isHoliday => marks.contains(DayMark.holiday);
  bool get isFestival => marks.contains(DayMark.festival);
  bool get hasEvent => marks.contains(DayMark.event);

  /// True for cells that share the cell's current display month.
  bool get isOutsideMonth => !isCurrentMonth;

  CalendarDayCell copyWith({
    CalendarDate? date,
    bool? isCurrentMonth,
    Set<DayMark>? marks,
    String? holidayLabelBn,
    String? holidayLabelEn,
  }) =>
      CalendarDayCell(
        date: date ?? this.date,
        isCurrentMonth: isCurrentMonth ?? this.isCurrentMonth,
        marks: marks ?? this.marks,
        holidayLabelBn: holidayLabelBn ?? this.holidayLabelBn,
        holidayLabelEn: holidayLabelEn ?? this.holidayLabelEn,
      );

  @override
  List<Object?> get props => <Object?>[
        date,
        isCurrentMonth,
        marks,
        holidayLabelBn,
        holidayLabelEn,
      ];
}

/// A 6-week (42-cell) Sat-first month view. Always returns 42 cells with
/// leading days from the previous month and trailing days from the next so
/// the grid is rectangular.
class MonthData extends Equatable {
  const MonthData({
    required this.year,
    required this.month,
    required this.cells,
  }) : assert(cells.length == 42, 'MonthData must have exactly 42 cells');

  final int year;
  final int month;
  final List<CalendarDayCell> cells;

  /// Cells that fall inside the displayed month.
  Iterable<CalendarDayCell> get inMonthCells =>
      cells.where((CalendarDayCell c) => c.isCurrentMonth);

  /// Find the cell for a specific Gregorian day, or null if it's outside.
  CalendarDayCell? cellFor(DateTime gregorian) {
    for (final CalendarDayCell c in cells) {
      if (c.date.isSameDay(gregorian)) return c;
    }
    return null;
  }

  @override
  List<Object?> get props => <Object?>[year, month, cells];
}
