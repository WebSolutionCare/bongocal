import 'package:equatable/equatable.dart';

import '../../../../core/utils/bangla_numerals.dart';

/// Bengali calendar names. Index 0 = Boishakh (Pohela Boishakh).
const List<String> banglaMonthNamesBn = <String>[
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

/// Latin transliterations used for English-mode display.
const List<String> banglaMonthNamesEn = <String>[
  'Boishakh',
  'Joishtho',
  'Ashar',
  'Srabon',
  'Bhadro',
  'Ashwin',
  'Kartik',
  'Ogrohayon',
  'Poush',
  'Magh',
  'Falgun',
  'Choitro',
];

/// A date in the Bengali calendar (Bangladeshi 2019 reformed civil calendar).
class BanglaDate extends Equatable {
  const BanglaDate({
    required this.day,
    required this.monthIndex,
    required this.year,
  }) : assert(day >= 1 && day <= 31, 'Bangla day out of range'),
       assert(
         monthIndex >= 0 && monthIndex < 12,
         'Bangla month index out of range',
       );

  final int day;
  final int monthIndex;
  final int year;

  String get monthNameBn => banglaMonthNamesBn[monthIndex];
  String get monthNameEn => banglaMonthNamesEn[monthIndex];

  /// `১৪ বৈশাখ ১৪৩৩`.
  String formatFullBn() =>
      '${BanglaNumerals.fromInt(day)} $monthNameBn ${BanglaNumerals.fromInt(year)}';

  /// `১৪ বৈশাখ` — used on the hero where the year is rendered separately.
  String formatDayMonthBn() =>
      '${BanglaNumerals.fromInt(day)} $monthNameBn';

  /// Bangla numerals for the year alone, e.g. `১৪৩৩`.
  String get yearBn => BanglaNumerals.fromInt(year);

  /// `14 Boishakh 1433` — Latin transliteration for English-language UI.
  String formatFullEn() => '$day $monthNameEn $year';

  @override
  List<Object?> get props => <Object?>[day, monthIndex, year];

  @override
  String toString() => formatFullBn();
}
