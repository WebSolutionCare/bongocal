/// User's chosen color scheme. `system` follows the device-level
/// light/dark setting.
enum ThemePreference { light, dark, system }

extension ThemePreferenceX on ThemePreference {
  String get displayBn {
    switch (this) {
      case ThemePreference.light:
        return 'উজ্জ্বল';
      case ThemePreference.dark:
        return 'অন্ধকার';
      case ThemePreference.system:
        return 'সিস্টেম';
    }
  }

  String get displayEn {
    switch (this) {
      case ThemePreference.light:
        return 'Light';
      case ThemePreference.dark:
        return 'Dark';
      case ThemePreference.system:
        return 'System';
    }
  }
}
