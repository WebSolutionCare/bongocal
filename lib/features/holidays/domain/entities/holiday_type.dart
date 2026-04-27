/// Classification of a holiday. Drives card colors, filter chips, and
/// sorting on the holidays list page.
enum HolidayType {
  /// National Days of state (Independence, Victory, Language Martyrs).
  governmentNational,

  /// Religious festivals (Eid, Puja, Christmas, Buddha Purnima …).
  religious,

  /// International observances officially recognized in BD (May Day).
  international,

  /// Optional / regional holidays — banks open, offices may close.
  optional,

  /// Cultural / awareness days that aren't government holidays
  /// (Mother's Day, Father's Day, Earth Day, …).
  observance,
}

extension HolidayTypeX on HolidayType {
  /// Display name in Bangla — used on filter chips and pills.
  String get displayNameBn {
    switch (this) {
      case HolidayType.governmentNational:
        return 'সরকারি';
      case HolidayType.religious:
        return 'ধর্মীয়';
      case HolidayType.international:
        return 'আন্তর্জাতিক';
      case HolidayType.optional:
        return 'ঐচ্ছিক';
      case HolidayType.observance:
        return 'পালনীয়';
    }
  }

  String get displayNameEn {
    switch (this) {
      case HolidayType.governmentNational:
        return 'Government';
      case HolidayType.religious:
        return 'Religious';
      case HolidayType.international:
        return 'International';
      case HolidayType.optional:
        return 'Optional';
      case HolidayType.observance:
        return 'Observance';
    }
  }

  /// Stable string key used in JSON + URLs.
  String get jsonKey {
    switch (this) {
      case HolidayType.governmentNational:
        return 'government_national';
      case HolidayType.religious:
        return 'religious';
      case HolidayType.international:
        return 'international';
      case HolidayType.optional:
        return 'optional';
      case HolidayType.observance:
        return 'observance';
    }
  }

  static HolidayType fromJsonKey(String key) {
    for (final HolidayType t in HolidayType.values) {
      if (t.jsonKey == key) return t;
    }
    throw ArgumentError('Unknown HolidayType json key: $key');
  }
}
