import 'package:bongocal/core/utils/bangla_numerals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BanglaNumerals.toBangla', () {
    test('converts plain digits', () {
      expect(BanglaNumerals.toBangla('0123456789'), '০১২৩৪৫৬৭৮৯');
    });

    test('preserves non-digit characters', () {
      expect(BanglaNumerals.toBangla('27 April 2026'), '২৭ April ২০২৬');
      expect(BanglaNumerals.toBangla('৳1,234.50'), '৳১,২৩৪.৫০');
    });

    test('empty string is empty', () {
      expect(BanglaNumerals.toBangla(''), '');
    });

    test('fromInt formats integers', () {
      expect(BanglaNumerals.fromInt(0), '০');
      expect(BanglaNumerals.fromInt(1432), '১৪৩২');
      expect(BanglaNumerals.fromInt(-7), '-৭');
    });
  });

  group('BanglaNumerals.toLatin', () {
    test('round-trips Bangla digits', () {
      const bn = '১৪ বৈশাখ ১৪৩২';
      expect(BanglaNumerals.toLatin(bn), '14 বৈশাখ 1432');
    });

    test('idempotent on Latin input', () {
      expect(BanglaNumerals.toLatin('27 April 2026'), '27 April 2026');
    });
  });

  group('BanglaNumerals.isAllBanglaDigits', () {
    test('true for all-Bangla digit strings', () {
      expect(BanglaNumerals.isAllBanglaDigits('০১২৩'), isTrue);
    });

    test('false for empty', () {
      expect(BanglaNumerals.isAllBanglaDigits(''), isFalse);
    });

    test('false for mixed strings', () {
      expect(BanglaNumerals.isAllBanglaDigits('১২ '), isFalse);
      expect(BanglaNumerals.isAllBanglaDigits('১২3'), isFalse);
    });
  });
}
