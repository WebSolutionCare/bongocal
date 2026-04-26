import '../../domain/entities/calendar_date.dart';
import 'bangla_date_model.dart';
import 'hijri_date_model.dart';

class CalendarDateModel extends CalendarDate {
  const CalendarDateModel({
    required super.gregorian,
    required super.bangla,
    required super.hijri,
    required super.weekdayIndexSatFirst,
  });

  factory CalendarDateModel.fromComputed({
    required DateTime gregorian,
    required BanglaDateModel bangla,
    required HijriDateModel hijri,
  }) =>
      CalendarDateModel(
        gregorian: DateTime(gregorian.year, gregorian.month, gregorian.day),
        bangla: bangla,
        hijri: hijri,
        weekdayIndexSatFirst: CalendarDate.satFirstIndex(gregorian),
      );
}
