import 'package:bongocal/features/holidays/domain/entities/holiday.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday_type.dart';

/// Test-only fixture builder so widget + unit tests don't repeat the
/// 10-field [Holiday] constructor.
Holiday testHoliday({
  required String id,
  required DateTime date,
  String? nameBn,
  String? nameEn,
  HolidayType type = HolidayType.governmentNational,
  bool isGovernmentHoliday = true,
}) =>
    Holiday(
      id: id,
      nameBn: nameBn ?? id,
      nameEn: nameEn ?? id,
      date: date,
      type: type,
      descriptionBn: '',
      descriptionEn: '',
      isGovernmentHoliday: isGovernmentHoliday,
      banksClosed: isGovernmentHoliday,
      isObservance: false,
    );
