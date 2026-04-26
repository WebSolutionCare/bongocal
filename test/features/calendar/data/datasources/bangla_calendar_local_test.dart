import 'package:bongocal/features/calendar/data/datasources/bangla_calendar_local.dart';
import 'package:bongocal/features/calendar/domain/entities/bangla_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const BanglaCalendarLocal cal = BanglaCalendarLocal();

  group('Pohela Boishakh anchor (2019 reformed)', () {
    test('April 14, 2026 → Boishakh 1, 1433', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 14));
      expect(d.day, 1);
      expect(d.monthIndex, 0);
      expect(d.monthNameBn, 'বৈশাখ');
      expect(d.year, 1433);
    });

    test('April 13, 2026 → Choitro 30, 1432 (last day of BS year)', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 13));
      expect(d.day, 30);
      expect(d.monthIndex, 11);
      expect(d.monthNameBn, 'চৈত্র');
      expect(d.year, 1432);
    });

    test('April 27, 2026 → Boishakh 14, 1433 (matches design fixture)', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 27));
      expect(d.day, 14);
      expect(d.monthIndex, 0);
      expect(d.year, 1433);
    });

    test('April 1, 2026 → Choitro 18, 1432', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 1));
      expect(d.day, 18);
      expect(d.monthIndex, 11);
      expect(d.year, 1432);
    });

    test('January 1, 2026 → Poush 18, 1432', () {
      final BanglaDate d = cal.convert(DateTime(2026, 1, 1));
      expect(d.day, 18);
      expect(d.monthIndex, 8);
      expect(d.monthNameBn, 'পৌষ');
      expect(d.year, 1432);
    });
  });

  group('leap-year handling', () {
    test('BS 1430 has Choitro 31 (Gregorian 2024 is leap)', () {
      // BS 1430 ran April 14, 2023 → April 13, 2024.
      // April 13, 2024 must be Choitro 31 in a leap BS year.
      final BanglaDate d = cal.convert(DateTime(2024, 4, 13));
      expect(d.day, 31);
      expect(d.monthIndex, 11);
      expect(d.year, 1430);
    });

    test('BS 1432 has Choitro 30 (Gregorian 2026 is non-leap)', () {
      // BS 1432 runs April 14, 2025 → April 13, 2026.
      // April 13, 2026 must be Choitro 30.
      final BanglaDate d = cal.convert(DateTime(2026, 4, 13));
      expect(d.day, 30);
    });
  });

  group('display formatting', () {
    test('formatFullBn uses Bangla numerals', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 27));
      expect(d.formatFullBn(), '১৪ বৈশাখ ১৪৩৩');
    });

    test('formatDayMonthBn omits the year', () {
      final BanglaDate d = cal.convert(DateTime(2026, 4, 27));
      expect(d.formatDayMonthBn(), '১৪ বৈশাখ');
    });
  });
}
