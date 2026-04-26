import 'package:equatable/equatable.dart';

import 'bangla_date.dart';
import 'hijri_date.dart';

/// Bangla weekday names indexed Sat-first (Bangladesh convention).
/// Sat=0, Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6.
const List<String> banglaWeekdaysSatFirst = <String>[
  'শনিবার',
  'রবিবার',
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
];

/// Short Bangla weekday labels for compact rows (week strip, month header).
const List<String> banglaWeekdaysShortSatFirst = <String>[
  'শনি',
  'রবি',
  'সোম',
  'মঙ্গল',
  'বুধ',
  'বৃহঃ',
  'শুক্র',
];

const List<String> englishWeekdayNames = <String>[
  'Saturday',
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
];

const List<String> englishWeekdayShortNames = <String>[
  'Sat',
  'Sun',
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
];

const List<String> englishMonthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> englishMonthShortNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// A single calendar day rendered across all three calendars BongoCal cares
/// about: Gregorian, Bengali, and Hijri.
///
/// The Sat-first weekday index follows Bangladesh convention; Friday (index 6)
/// is the local weekend.
class CalendarDate extends Equatable {
  const CalendarDate({
    required this.gregorian,
    required this.bangla,
    required this.hijri,
    required this.weekdayIndexSatFirst,
  }) : assert(
          weekdayIndexSatFirst >= 0 && weekdayIndexSatFirst < 7,
          'weekdayIndexSatFirst out of range',
        );

  final DateTime gregorian;
  final BanglaDate bangla;
  final HijriDate hijri;
  final int weekdayIndexSatFirst;

  /// Sat-first weekday index from a Dart [DateTime]. Dart uses Mon=1…Sun=7.
  /// Sat-first puts Sat=0, Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6.
  static int satFirstIndex(DateTime date) {
    // Map: Sat(6) → 0, Sun(7) → 1, Mon(1) → 2, … Fri(5) → 6.
    return (date.weekday + 1) % 7;
  }

  /// True if this date lands on a Friday — the Bangladesh weekend.
  bool get isFriday => weekdayIndexSatFirst == 6;

  String get banglaWeekday => banglaWeekdaysSatFirst[weekdayIndexSatFirst];
  String get banglaWeekdayShort =>
      banglaWeekdaysShortSatFirst[weekdayIndexSatFirst];
  String get englishWeekday => englishWeekdayNames[weekdayIndexSatFirst];
  String get englishWeekdayShort =>
      englishWeekdayShortNames[weekdayIndexSatFirst];

  String get englishMonthName => englishMonthNames[gregorian.month - 1];
  String get englishMonthShort => englishMonthShortNames[gregorian.month - 1];

  /// `27 April 2026`.
  String formatGregorianLong() =>
      '${gregorian.day} $englishMonthName ${gregorian.year}';

  /// `27 Apr`.
  String formatGregorianShort() => '${gregorian.day} $englishMonthShort';

  bool isSameDay(DateTime other) =>
      gregorian.year == other.year &&
      gregorian.month == other.month &&
      gregorian.day == other.day;

  @override
  List<Object?> get props => <Object?>[
        gregorian,
        bangla,
        hijri,
        weekdayIndexSatFirst,
      ];
}
