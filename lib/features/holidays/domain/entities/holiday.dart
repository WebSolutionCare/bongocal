import 'package:equatable/equatable.dart';

import 'holiday_type.dart';

/// A single holiday or observance day in the Bangladesh calendar.
///
/// All dates are Gregorian; conversion to Bengali / Hijri happens via the
/// calendar feature. Time-of-day is intentionally midnight — holidays are
/// whole-day affairs.
class Holiday extends Equatable {
  const Holiday({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.date,
    required this.type,
    required this.descriptionBn,
    required this.descriptionEn,
    required this.isGovernmentHoliday,
    required this.banksClosed,
    required this.isObservance,
  });

  /// Stable slug — used in URLs (`/holidays/:id`).
  final String id;
  final String nameBn;
  final String nameEn;
  final DateTime date;
  final HolidayType type;
  final String descriptionBn;
  final String descriptionEn;

  /// True if this is on the Bangladesh public-holiday list (offices closed).
  final bool isGovernmentHoliday;

  /// True if banks observe this day (subset of `isGovernmentHoliday`).
  final bool banksClosed;

  /// True if this is purely cultural/awareness (Mother's Day) — never a
  /// public holiday even if `type` is observance.
  final bool isObservance;

  /// True if this is a religious festival (used by the calendar's gold-disc
  /// festival mark).
  bool get isFestival => type == HolidayType.religious;

  @override
  List<Object?> get props => <Object?>[
        id,
        nameBn,
        nameEn,
        date,
        type,
        descriptionBn,
        descriptionEn,
        isGovernmentHoliday,
        banksClosed,
        isObservance,
      ];
}
