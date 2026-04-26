/// Convert between Latin (0-9) and Bangla (০-৯) digit characters.
///
/// Per the brand voice: Bangla numerals appear when surrounding text is
/// Bangla. Use [toBangla] when rendering numbers in a Bangla context;
/// use [toLatin] when normalizing user input or comparing strings.
class BanglaNumerals {
  const BanglaNumerals._();

  static const List<String> _banglaDigits = <String>[
    '০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯',
  ];

  // Bangla digits start at U+09E6 ('০') and end at U+09EF ('৯').
  static const int _banglaZero = 0x09E6;
  static const int _banglaNine = 0x09EF;

  // Latin '0' = 0x30, '9' = 0x39.
  static const int _latinZero = 0x30;
  static const int _latinNine = 0x39;

  /// Replace every Latin digit in [input] with the corresponding Bangla
  /// digit. Non-digit characters are preserved.
  static String toBangla(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= _latinZero && rune <= _latinNine) {
        buffer.write(_banglaDigits[rune - _latinZero]);
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// Convenience for `toBangla(value.toString())`.
  static String fromInt(int value) => toBangla(value.toString());

  /// Replace every Bangla digit in [input] with the corresponding Latin
  /// digit. Useful when normalizing user-entered numbers.
  static String toLatin(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      if (rune >= _banglaZero && rune <= _banglaNine) {
        buffer.writeCharCode(_latinZero + (rune - _banglaZero));
      } else {
        buffer.writeCharCode(rune);
      }
    }
    return buffer.toString();
  }

  /// True if [input] contains only Bangla digit characters (no separators,
  /// no whitespace). Empty string returns false.
  static bool isAllBanglaDigits(String input) {
    if (input.isEmpty) return false;
    for (final rune in input.runes) {
      if (rune < _banglaZero || rune > _banglaNine) return false;
    }
    return true;
  }
}
