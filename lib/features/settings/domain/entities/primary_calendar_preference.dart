/// The calendar that headlines on date displays — the other two
/// (Bangla, Hijri or English) still appear as supporting context.
enum PrimaryCalendarPreference { english, bangla, hijri }

extension PrimaryCalendarPreferenceX on PrimaryCalendarPreference {
  String get displayBn {
    switch (this) {
      case PrimaryCalendarPreference.english:
        return 'English';
      case PrimaryCalendarPreference.bangla:
        return 'বাংলা';
      case PrimaryCalendarPreference.hijri:
        return 'হিজরি';
    }
  }
}
