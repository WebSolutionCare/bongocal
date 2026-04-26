import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/hijri_date.dart';

/// Wraps the `hijri` package (Umm al-Qura) so the rest of the codebase
/// depends on our [HijriDate] entity rather than the package's mutable type.
///
/// Bangladesh follows local moon-sighting which can differ from Umm al-Qura
/// by ±1 day; we surface the package's output today and may add a manual
/// adjustment offset later.
class HijriCalendarLocal {
  const HijriCalendarLocal();

  HijriDate convert(DateTime gregorian) {
    final DateTime g = DateTime(gregorian.year, gregorian.month, gregorian.day);
    final HijriCalendar h = HijriCalendar.fromDate(g);
    return HijriDate(day: h.hDay, month: h.hMonth, year: h.hYear);
  }
}
