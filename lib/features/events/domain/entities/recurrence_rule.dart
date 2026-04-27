/// Repeat cadence for personal events.
enum RecurrenceRule { none, daily, weekly, monthly, yearly }

extension RecurrenceRuleX on RecurrenceRule {
  String get displayBn {
    switch (this) {
      case RecurrenceRule.none:
        return 'কখনো না';
      case RecurrenceRule.daily:
        return 'প্রতিদিন';
      case RecurrenceRule.weekly:
        return 'প্রতি সপ্তাহে';
      case RecurrenceRule.monthly:
        return 'প্রতি মাসে';
      case RecurrenceRule.yearly:
        return 'প্রতি বছর';
    }
  }

  String get displayEn {
    switch (this) {
      case RecurrenceRule.none:
        return 'Never';
      case RecurrenceRule.daily:
        return 'Daily';
      case RecurrenceRule.weekly:
        return 'Weekly';
      case RecurrenceRule.monthly:
        return 'Monthly';
      case RecurrenceRule.yearly:
        return 'Yearly';
    }
  }
}

/// Calendar in which the user originally entered the date — used for display
/// preference only; the persisted [DateTime] is always Gregorian.
enum EventCalendarType { english, bangla, hijri }

extension EventCalendarTypeX on EventCalendarType {
  String get displayBn {
    switch (this) {
      case EventCalendarType.english:
        return 'English';
      case EventCalendarType.bangla:
        return 'বাংলা';
      case EventCalendarType.hijri:
        return 'হিজরি';
    }
  }
}
