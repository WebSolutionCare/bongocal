import 'package:bongocal/features/calendar/data/datasources/hijri_calendar_local.dart';
import 'package:bongocal/features/calendar/domain/entities/hijri_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const HijriCalendarLocal cal = HijriCalendarLocal();

  test('returns a valid Hijri date for an arbitrary Gregorian date', () {
    // We do not pin the exact Umm al-Qura output (the underlying package may
    // adjust by ±1 day in future versions); we assert structural validity
    // and a plausible year window.
    final HijriDate d = cal.convert(DateTime(2026, 4, 27));
    expect(d.day, inInclusiveRange(1, 30));
    expect(d.month, inInclusiveRange(1, 12));
    expect(d.year, inInclusiveRange(1446, 1448));
  });

  test('moves forward one Hijri day when Gregorian moves forward one day', () {
    final HijriDate a = cal.convert(DateTime(2026, 4, 27));
    final HijriDate b = cal.convert(DateTime(2026, 4, 28));

    // Either same month → b.day == a.day + 1, or month boundary.
    if (a.month == b.month && a.year == b.year) {
      expect(b.day, a.day + 1);
    } else {
      expect(b.day, 1);
    }
  });

  test('Bangla month name lookup is consistent with month number', () {
    final HijriDate d = cal.convert(DateTime(2026, 4, 27));
    expect(d.monthNameBn.isNotEmpty, isTrue);
    expect(d.monthIndex, d.month - 1);
  });
}
