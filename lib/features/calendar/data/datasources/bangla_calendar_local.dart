import '../../domain/entities/bangla_date.dart';

/// 2019 Bangladesh-reformed Bengali civil calendar.
///
/// Rules:
/// * Pohela Boishakh is fixed to **April 14** in the Gregorian calendar.
/// * Months 1–5 (Boishakh … Bhadro) have **31 days**.
/// * Months 6–11 (Ashwin … Falgun) have **30 days**.
/// * Month 12 (Choitro) has **30 days**, **31** in BS leap years.
/// * A BS year `bsY` is leap iff the Gregorian year `bsY + 594` is leap —
///   i.e. the Gregorian year containing that BS year's Choitro.
class BanglaCalendarLocal {
  const BanglaCalendarLocal();

  /// Convert any Gregorian [DateTime] to a [BanglaDate]. Time-of-day is
  /// ignored; we anchor on the calendar day.
  BanglaDate convert(DateTime gregorian) {
    final DateTime g = DateTime(gregorian.year, gregorian.month, gregorian.day);
    final DateTime pohelaThisYear = DateTime(g.year, DateTime.april, 14);

    final int bsYear;
    final DateTime anchor;
    if (!g.isBefore(pohelaThisYear)) {
      bsYear = g.year - 593;
      anchor = pohelaThisYear;
    } else {
      bsYear = g.year - 594;
      anchor = DateTime(g.year - 1, DateTime.april, 14);
    }

    final int daysIntoYear = g.difference(anchor).inDays;
    final List<int> monthLengths = _monthLengths(bsYear);

    int remaining = daysIntoYear;
    int monthIndex = 0;
    for (int i = 0; i < monthLengths.length; i++) {
      if (remaining < monthLengths[i]) {
        monthIndex = i;
        break;
      }
      remaining -= monthLengths[i];
    }

    return BanglaDate(
      day: remaining + 1,
      monthIndex: monthIndex,
      year: bsYear,
    );
  }

  /// Length-12 list of month lengths for a given BS year.
  List<int> _monthLengths(int bsYear) {
    final bool isLeap = _isLeap(bsYear);
    return <int>[
      31, 31, 31, 31, 31, // Boishakh – Bhadro
      30, 30, 30, 30, 30, 30, // Ashwin – Falgun
      isLeap ? 31 : 30, // Choitro
    ];
  }

  bool _isLeap(int bsYear) {
    final int g = bsYear + 594;
    return (g % 4 == 0 && g % 100 != 0) || g % 400 == 0;
  }
}
