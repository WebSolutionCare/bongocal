import 'package:equatable/equatable.dart';

import '../../../../core/utils/bangla_numerals.dart';

/// Hijri month names in Bangla transliteration. Index 0 = মুহাররম (month 1).
const List<String> hijriMonthNamesBn = <String>[
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

/// Hijri month names in Latin (matches the `hijri` package's `longMonthName`).
const List<String> hijriMonthNamesEn = <String>[
  'Muharram',
  'Safar',
  'Rabi al-Awwal',
  'Rabi al-Thani',
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhu al-Qa'dah",
  'Dhu al-Hijjah',
];

/// A date in the Hijri (Islamic lunar) calendar. `month` is 1-based for
/// alignment with the upstream `hijri` package; [monthIndex] is the 0-based
/// equivalent for indexing the name lists above.
class HijriDate extends Equatable {
  const HijriDate({
    required this.day,
    required this.month,
    required this.year,
  }) : assert(day >= 1 && day <= 30, 'Hijri day out of range'),
       assert(month >= 1 && month <= 12, 'Hijri month out of range');

  final int day;
  final int month;
  final int year;

  int get monthIndex => month - 1;
  String get monthNameBn => hijriMonthNamesBn[monthIndex];
  String get monthNameEn => hijriMonthNamesEn[monthIndex];

  /// `৯ শাওয়াল ১৪৪৭` (or `9 শাওয়াল 1447` when [useBanglaNumerals] is false).
  String formatFullBn({bool useBanglaNumerals = true}) =>
      '${_n(day, useBanglaNumerals)} $monthNameBn ${_n(year, useBanglaNumerals)}';

  /// `৯ শাওয়াল`.
  String formatDayMonthBn({bool useBanglaNumerals = true}) =>
      '${_n(day, useBanglaNumerals)} $monthNameBn';

  /// Year alone in either numeral system.
  String yearBnFormatted({bool useBanglaNumerals = true}) =>
      _n(year, useBanglaNumerals);

  /// Convenience: always-Bangla year.
  String get yearBn => _n(year, true);

  static String _n(int v, bool bn) =>
      bn ? BanglaNumerals.fromInt(v) : v.toString();

  /// `9 Shawwal 1447`.
  String formatFullEn() => '$day $monthNameEn $year';

  @override
  List<Object?> get props => <Object?>[day, month, year];

  @override
  String toString() => formatFullBn();
}
