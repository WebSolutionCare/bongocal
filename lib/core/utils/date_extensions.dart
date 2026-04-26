import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import 'bangla_numerals.dart';

/// Bangla month names (বৈশাখ … চৈত্র). Index 0 is বৈশাখ (Boishakh).
const List<String> banglaMonths = <String>[
  'বৈশাখ',
  'জ্যৈষ্ঠ',
  'আষাঢ়',
  'শ্রাবণ',
  'ভাদ্র',
  'আশ্বিন',
  'কার্তিক',
  'অগ্রহায়ণ',
  'পৌষ',
  'মাঘ',
  'ফাল্গুন',
  'চৈত্র',
];

/// Bangla weekday names. Index 0 is রবিবার (Sunday) to mirror Dart's
/// `DateTime.weekday` minus 1 once normalized — see [DateExtensions.banglaWeekday].
const List<String> banglaWeekdays = <String>[
  'রবিবার',
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
  'শনিবার',
];

/// Hijri month names in Bangla transliteration.
const List<String> hijriMonthsBangla = <String>[
  'মুহাররম',
  'সফর',
  'রবিউল আউয়াল',
  'রবিউস সানি',
  'জমাদিউল আউয়াল',
  'জমাদিউস সানি',
  'রজব',
  'শাবান',
  'রমজান',
  'শাওয়াল',
  'যিলক্বদ',
  'যিলহজ্জ',
];

/// Date helpers for the three calendars BongoCal renders.
///
/// English (Gregorian) format follows `27 April 2026` per design system.
/// Bangla format follows `১৪ বৈশাখ ১৪৩২`. Hijri format follows
/// `৯ যিলক্বদ ১৪৪৭`.
extension DateExtensions on DateTime {
  /// English format: `27 April 2026`.
  String formatEnglish() => DateFormat('d MMMM y').format(this);

  /// English short: `27 Apr`.
  String formatEnglishShort() => DateFormat('d MMM').format(this);

  /// Bangla weekday name for this date (e.g. সোমবার).
  String get banglaWeekday {
    // DateTime.weekday: Mon=1 … Sun=7. We index from Sun=0.
    final index = weekday == DateTime.sunday ? 0 : weekday;
    return banglaWeekdays[index];
  }

  /// Approximate Bengali calendar conversion.
  ///
  /// The Bengali year begins on Pohela Boishakh — historically April 14 in
  /// Bangladesh under the revised civil calendar (Bangladesh adopted the
  /// 2019 reform that fixes the new year to April 14). This helper returns
  /// a `(year, monthIndex, day)` tuple where `monthIndex` is 0-based into
  /// [banglaMonths]. For first-class accuracy across all edge cases (leap
  /// adjustments, religious observance variants), wire this through a
  /// dedicated package in the calendar feature; this helper is a sane
  /// default for placeholder UI.
  ({int year, int monthIndex, int day}) toBengaliApprox() {
    // Bengali new year = April 14. Bengali year offset = -593 before April 14,
    // -594 on/after April 14 of the same Gregorian year is wrong — actually
    // for Bangladesh: BS = AD - 593 if month/day >= April 14, else AD - 594.
    final newYear = DateTime(year, DateTime.april, 14);
    final bsYear = isBefore(newYear) ? year - 594 : year - 593;

    // Day-of-year offset from April 14.
    final anchor = isBefore(newYear)
        ? DateTime(year - 1, DateTime.april, 14)
        : newYear;
    final daysSinceNewYear = difference(anchor).inDays;

    // Revised Bangladeshi civil calendar (2019): Boishakh-Bhadra = 31 days,
    // Ashwin-Falgun = 30 days, Chaitra = 30 (31 in BS leap years that match
    // Gregorian leap years).
    final monthLengths = <int>[31, 31, 31, 31, 31, 30, 30, 30, 30, 30, 30, 30];
    // Chaitra leap day mirrors Gregorian leap year of (bsYear + 594) i.e. the
    // Gregorian year containing the *following* Pohela Boishakh.
    final nextGregYear = bsYear + 594;
    final isLeap = (nextGregYear % 4 == 0 && nextGregYear % 100 != 0) ||
        nextGregYear % 400 == 0;
    if (isLeap) monthLengths[11] = 31;

    var remaining = daysSinceNewYear;
    var monthIndex = 0;
    for (var i = 0; i < monthLengths.length; i++) {
      if (remaining < monthLengths[i]) {
        monthIndex = i;
        break;
      }
      remaining -= monthLengths[i];
    }
    final day = remaining + 1;
    return (year: bsYear, monthIndex: monthIndex, day: day);
  }

  /// Bangla-formatted Bengali date: `১৪ বৈশাখ ১৪৩২`.
  String formatBengali() {
    final bs = toBengaliApprox();
    final day = BanglaNumerals.fromInt(bs.day);
    final year = BanglaNumerals.fromInt(bs.year);
    return '$day ${banglaMonths[bs.monthIndex]} $year';
  }

  /// Bangla-formatted Hijri date: `৯ যিলক্বদ ১৪৪৭`.
  String formatHijriBangla() {
    final h = HijriCalendar.fromDate(this);
    final day = BanglaNumerals.fromInt(h.hDay);
    final year = BanglaNumerals.fromInt(h.hYear);
    // hMonth is 1-based.
    final month = hijriMonthsBangla[h.hMonth - 1];
    return '$day $month $year';
  }

  /// Latin-formatted Hijri date: `9 Dhu al-Qadah 1447` (uses package's
  /// long names).
  String formatHijriEnglish() {
    final h = HijriCalendar.fromDate(this);
    return '${h.hDay} ${h.longMonthName} ${h.hYear}';
  }

  /// Whether this date falls on the same calendar day as [other], ignoring
  /// time-of-day.
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Midnight of this date (drops time-of-day).
  DateTime get startOfDay => DateTime(year, month, day);
}
