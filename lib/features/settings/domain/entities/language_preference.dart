/// App-wide UI language.
enum LanguagePreference { bangla, english }

extension LanguagePreferenceX on LanguagePreference {
  String get displayBn {
    switch (this) {
      case LanguagePreference.bangla:
        return 'বাংলা';
      case LanguagePreference.english:
        return 'English';
    }
  }

  String get displayEn => displayBn; // Bangla / English are the same in either UI.

  /// Locale tag passed to `MaterialApp.locale`.
  String get languageCode {
    switch (this) {
      case LanguagePreference.bangla:
        return 'bn';
      case LanguagePreference.english:
        return 'en';
    }
  }

  String get countryCode {
    switch (this) {
      case LanguagePreference.bangla:
        return 'BD';
      case LanguagePreference.english:
        return 'US';
    }
  }
}
